-- Fonction pour récupérer les offres proches d'une position
CREATE OR REPLACE FUNCTION get_nearby_offers(
    user_lat DOUBLE PRECISION,
    user_lng DOUBLE PRECISION,
    radius_km DOUBLE PRECISION DEFAULT 5.0,
    limit_count INTEGER DEFAULT 20
)
RETURNS TABLE(
    id UUID,
    merchant_id UUID,
    title TEXT,
    description TEXT,
    images TEXT[],
    original_price DECIMAL(10,2),
    discounted_price DECIMAL(10,2),
    quantity_available INTEGER,
    pickup_start_time TIME,
    pickup_end_time TIME,
    available_date DATE,
    status offer_status,
    is_urgent BOOLEAN,
    allergens TEXT[],
    dietary_info JSONB,
    nutritional_info JSONB,
    tags TEXT[],
    views_count INTEGER,
    quantity_sold INTEGER,
    created_at TIMESTAMPTZ,
    updated_at TIMESTAMPTZ,
    merchant JSONB,
    distance_km DOUBLE PRECISION
) AS $$
BEGIN
    RETURN QUERY
    WITH merchant_locations AS (
        SELECT DISTINCT ON (m.id)
            m.id AS merchant_id,
            m.business_name,
            m.logo_url,
            m.rating,
            m.total_reviews,
            a.latitude,
            a.longitude,
            a.address_line1,
            a.address_line2,
            a.city,
            a.postal_code,
            -- Calcul de la distance en km
            (
                6371 * acos(
                    cos(radians(user_lat)) * cos(radians(a.latitude)) *
                    cos(radians(a.longitude) - radians(user_lng)) +
                    sin(radians(user_lat)) * sin(radians(a.latitude))
                )
            ) AS distance_km
        FROM merchants m
        INNER JOIN addresses a ON a.merchant_id = m.id
        WHERE a.latitude IS NOT NULL 
          AND a.longitude IS NOT NULL
          AND a.is_primary = true
    )
    SELECT 
        fo.id,
        fo.merchant_id,
        fo.title,
        fo.description,
        fo.images,
        fo.original_price,
        fo.discounted_price,
        fo.quantity_available,
        fo.pickup_start_time,
        fo.pickup_end_time,
        fo.available_date,
        fo.status,
        fo.is_urgent,
        fo.allergens,
        fo.dietary_info,
        fo.nutritional_info,
        fo.tags,
        fo.views_count,
        fo.quantity_sold,
        fo.created_at,
        fo.updated_at,
        jsonb_build_object(
            'id', ml.merchant_id,
            'business_name', ml.business_name,
            'logo_url', ml.logo_url,
            'rating', ml.rating,
            'total_reviews', ml.total_reviews,
            'addresses', jsonb_build_array(
                jsonb_build_object(
                    'latitude', ml.latitude,
                    'longitude', ml.longitude,
                    'address_line1', ml.address_line1,
                    'address_line2', ml.address_line2,
                    'city', ml.city,
                    'postal_code', ml.postal_code
                )
            )
        ) AS merchant,
        ml.distance_km
    FROM food_offers fo
    INNER JOIN merchant_locations ml ON ml.merchant_id = fo.merchant_id
    WHERE fo.status = 'active'
      AND fo.quantity_available > 0
      AND ml.distance_km <= radius_km
      AND (fo.expiry_datetime IS NULL OR fo.expiry_datetime > NOW())
    ORDER BY 
        fo.is_urgent DESC,
        ml.distance_km ASC
    LIMIT limit_count;
END;
$$ LANGUAGE plpgsql;

-- Index pour améliorer les performances
CREATE INDEX IF NOT EXISTS idx_addresses_merchant_primary 
    ON addresses(merchant_id) 
    WHERE is_primary = true;

-- Donner les permissions d'exécution
GRANT EXECUTE ON FUNCTION get_nearby_offers TO authenticated;
GRANT EXECUTE ON FUNCTION get_nearby_offers TO anon;