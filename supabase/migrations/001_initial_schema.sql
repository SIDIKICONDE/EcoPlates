-- ==============================================
-- ECOPLATES - Schéma de base de données Supabase
-- ==============================================

-- Activer les extensions nécessaires
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "postgis";

-- ==============================================
-- TYPES ET ENUMS
-- ==============================================

-- Type d'utilisateur
CREATE TYPE user_type AS ENUM ('consumer', 'merchant', 'admin');

-- Statut des offres
CREATE TYPE offer_status AS ENUM ('active', 'sold_out', 'expired', 'draft', 'cancelled');

-- Statut des commandes
CREATE TYPE order_status AS ENUM ('pending', 'confirmed', 'preparing', 'ready', 'collected', 'cancelled');

-- Statut des réservations
CREATE TYPE reservation_status AS ENUM ('pending', 'confirmed', 'cancelled', 'completed', 'expired');

-- Type de promotion
CREATE TYPE promotion_type AS ENUM ('percentage', 'fixed_amount', 'buy_one_get_one', 'flash_sale');

-- Statut des articles de stock
CREATE TYPE stock_status AS ENUM ('in_stock', 'low_stock', 'out_of_stock', 'discontinued');

-- ==============================================
-- TABLES PRINCIPALES
-- ==============================================

-- Table des utilisateurs (extension de auth.users)
CREATE TABLE public.users (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT UNIQUE NOT NULL,
    full_name TEXT,
    phone_number TEXT,
    user_type user_type NOT NULL DEFAULT 'consumer',
    avatar_url TEXT,
    is_active BOOLEAN DEFAULT true,
    preferences JSONB DEFAULT '{}',
    notification_settings JSONB DEFAULT '{"email": true, "push": true, "sms": false}',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table des marchands
CREATE TABLE public.merchants (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
    business_name TEXT NOT NULL,
    business_registration TEXT,
    tax_id TEXT,
    logo_url TEXT,
    cover_image_url TEXT,
    description TEXT,
    cuisine_types TEXT[],
    contact_email TEXT,
    contact_phone TEXT,
    website TEXT,
    social_media JSONB DEFAULT '{}',
    is_verified BOOLEAN DEFAULT false,
    is_featured BOOLEAN DEFAULT false,
    rating DECIMAL(3,2) DEFAULT 0,
    total_reviews INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table des profils marchands (informations complémentaires)
CREATE TABLE public.merchant_profiles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    merchant_id UUID UNIQUE REFERENCES public.merchants(id) ON DELETE CASCADE,
    opening_hours JSONB DEFAULT '{}',
    delivery_options JSONB DEFAULT '{}',
    payment_methods TEXT[] DEFAULT '{}',
    sustainability_score INTEGER CHECK (sustainability_score >= 0 AND sustainability_score <= 100),
    eco_certifications TEXT[],
    minimum_order_amount DECIMAL(10,2),
    delivery_fee DECIMAL(10,2),
    preparation_time_minutes INTEGER,
    commission_rate DECIMAL(5,2) DEFAULT 15.00,
    bank_details JSONB DEFAULT '{}',
    settings JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table des adresses
CREATE TABLE public.addresses (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    merchant_id UUID REFERENCES public.merchants(id) ON DELETE CASCADE,
    user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
    address_line1 TEXT NOT NULL,
    address_line2 TEXT,
    city TEXT NOT NULL,
    postal_code TEXT NOT NULL,
    country TEXT DEFAULT 'France',
    latitude DECIMAL(10,8),
    longitude DECIMAL(11,8),
    location GEOGRAPHY(POINT),
    is_primary BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    CONSTRAINT address_owner CHECK (
        (merchant_id IS NOT NULL AND user_id IS NULL) OR 
        (merchant_id IS NULL AND user_id IS NOT NULL)
    )
);

-- Table des catégories
CREATE TABLE public.categories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT UNIQUE NOT NULL,
    slug TEXT UNIQUE NOT NULL,
    description TEXT,
    icon TEXT,
    parent_id UUID REFERENCES public.categories(id),
    display_order INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table des marques
CREATE TABLE public.brands (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT UNIQUE NOT NULL,
    slug TEXT UNIQUE NOT NULL,
    logo_url TEXT,
    description TEXT,
    website TEXT,
    is_eco_friendly BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table des offres alimentaires
CREATE TABLE public.food_offers (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    merchant_id UUID REFERENCES public.merchants(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    description TEXT,
    category_id UUID REFERENCES public.categories(id),
    brand_id UUID REFERENCES public.brands(id),
    images TEXT[],
    original_price DECIMAL(10,2) NOT NULL,
    discounted_price DECIMAL(10,2) NOT NULL,
    discount_percentage INTEGER GENERATED ALWAYS AS (
        CASE WHEN original_price > 0 
        THEN ROUND(((original_price - discounted_price) / original_price * 100)::numeric, 0)
        ELSE 0 END
    ) STORED,
    quantity_available INTEGER NOT NULL DEFAULT 0,
    quantity_sold INTEGER DEFAULT 0,
    pickup_start_time TIME,
    pickup_end_time TIME,
    available_date DATE,
    expiry_datetime TIMESTAMPTZ,
    allergens TEXT[],
    dietary_info JSONB DEFAULT '{}',
    nutritional_info JSONB DEFAULT '{}',
    status offer_status DEFAULT 'draft',
    is_urgent BOOLEAN DEFAULT false,
    is_featured BOOLEAN DEFAULT false,
    tags TEXT[],
    views_count INTEGER DEFAULT 0,
    saves_count INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table des commandes
CREATE TABLE public.orders (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_number TEXT UNIQUE NOT NULL,
    user_id UUID REFERENCES public.users(id),
    merchant_id UUID REFERENCES public.merchants(id),
    items JSONB NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    tax_amount DECIMAL(10,2) DEFAULT 0,
    delivery_fee DECIMAL(10,2) DEFAULT 0,
    discount_amount DECIMAL(10,2) DEFAULT 0,
    total_amount DECIMAL(10,2) NOT NULL,
    status order_status DEFAULT 'pending',
    payment_method TEXT,
    payment_status TEXT,
    pickup_time TIMESTAMPTZ,
    notes TEXT,
    qr_code TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table des réservations
CREATE TABLE public.reservations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
    food_offer_id UUID REFERENCES public.food_offers(id) ON DELETE CASCADE,
    order_id UUID REFERENCES public.orders(id),
    quantity INTEGER NOT NULL DEFAULT 1,
    total_price DECIMAL(10,2) NOT NULL,
    status reservation_status DEFAULT 'pending',
    reservation_code TEXT UNIQUE,
    pickup_time TIMESTAMPTZ,
    expires_at TIMESTAMPTZ,
    confirmed_at TIMESTAMPTZ,
    collected_at TIMESTAMPTZ,
    cancelled_at TIMESTAMPTZ,
    cancellation_reason TEXT,
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table des articles de stock
CREATE TABLE public.stock_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    merchant_id UUID REFERENCES public.merchants(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    sku TEXT,
    barcode TEXT,
    category_id UUID REFERENCES public.categories(id),
    unit TEXT DEFAULT 'piece',
    current_quantity DECIMAL(10,2) NOT NULL DEFAULT 0,
    minimum_quantity DECIMAL(10,2) DEFAULT 0,
    maximum_quantity DECIMAL(10,2),
    unit_cost DECIMAL(10,2),
    selling_price DECIMAL(10,2),
    status stock_status DEFAULT 'in_stock',
    supplier_info JSONB DEFAULT '{}',
    expiry_date DATE,
    batch_number TEXT,
    storage_location TEXT,
    image_url TEXT,
    is_perishable BOOLEAN DEFAULT false,
    alert_threshold DECIMAL(10,2),
    last_restock_date DATE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table des ventes
CREATE TABLE public.sales (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    merchant_id UUID REFERENCES public.merchants(id) ON DELETE CASCADE,
    order_id UUID REFERENCES public.orders(id),
    sale_date DATE NOT NULL DEFAULT CURRENT_DATE,
    total_amount DECIMAL(10,2) NOT NULL,
    tax_amount DECIMAL(10,2) DEFAULT 0,
    discount_amount DECIMAL(10,2) DEFAULT 0,
    net_amount DECIMAL(10,2) GENERATED ALWAYS AS (total_amount - tax_amount - discount_amount) STORED,
    payment_method TEXT,
    customer_id UUID REFERENCES public.users(id),
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table des articles vendus
CREATE TABLE public.sale_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    sale_id UUID REFERENCES public.sales(id) ON DELETE CASCADE,
    stock_item_id UUID REFERENCES public.stock_items(id),
    food_offer_id UUID REFERENCES public.food_offers(id),
    quantity DECIMAL(10,2) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    discount_amount DECIMAL(10,2) DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    CONSTRAINT sale_item_product CHECK (
        (stock_item_id IS NOT NULL AND food_offer_id IS NULL) OR 
        (stock_item_id IS NULL AND food_offer_id IS NOT NULL)
    )
);

-- Table des codes QR
CREATE TABLE public.qr_codes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    code TEXT UNIQUE NOT NULL,
    order_id UUID REFERENCES public.orders(id),
    reservation_id UUID REFERENCES public.reservations(id),
    merchant_id UUID REFERENCES public.merchants(id),
    user_id UUID REFERENCES public.users(id),
    type TEXT NOT NULL,
    payload JSONB NOT NULL,
    is_used BOOLEAN DEFAULT false,
    used_at TIMESTAMPTZ,
    expires_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table des scans QR
CREATE TABLE public.qr_scans (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    qr_code_id UUID REFERENCES public.qr_codes(id),
    scanned_by UUID REFERENCES public.users(id),
    merchant_id UUID REFERENCES public.merchants(id),
    scan_location GEOGRAPHY(POINT),
    device_info JSONB,
    is_valid BOOLEAN,
    validation_errors TEXT[],
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table des favoris
CREATE TABLE public.favorites (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
    merchant_id UUID REFERENCES public.merchants(id) ON DELETE CASCADE,
    food_offer_id UUID REFERENCES public.food_offers(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    CONSTRAINT favorite_target CHECK (
        (merchant_id IS NOT NULL AND food_offer_id IS NULL) OR 
        (merchant_id IS NULL AND food_offer_id IS NOT NULL)
    ),
    CONSTRAINT unique_user_merchant UNIQUE (user_id, merchant_id),
    CONSTRAINT unique_user_offer UNIQUE (user_id, food_offer_id)
);

-- Table des avis et évaluations
CREATE TABLE public.reviews (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
    merchant_id UUID REFERENCES public.merchants(id),
    food_offer_id UUID REFERENCES public.food_offers(id),
    order_id UUID REFERENCES public.orders(id),
    rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    images TEXT[],
    is_verified_purchase BOOLEAN DEFAULT false,
    helpful_count INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table des notifications
CREATE TABLE public.notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    message TEXT NOT NULL,
    type TEXT NOT NULL,
    data JSONB DEFAULT '{}',
    is_read BOOLEAN DEFAULT false,
    read_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table d'analytics
CREATE TABLE public.analytics_events (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES public.users(id),
    merchant_id UUID REFERENCES public.merchants(id),
    event_type TEXT NOT NULL,
    event_data JSONB DEFAULT '{}',
    session_id TEXT,
    device_info JSONB DEFAULT '{}',
    location GEOGRAPHY(POINT),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ==============================================
-- INDEX POUR OPTIMISATION
-- ==============================================

-- Index sur les recherches géographiques
CREATE INDEX idx_addresses_location ON addresses USING GIST (location);
CREATE INDEX idx_qr_scans_location ON qr_scans USING GIST (scan_location);
CREATE INDEX idx_analytics_location ON analytics_events USING GIST (location);

-- Index sur les recherches fréquentes
CREATE INDEX idx_food_offers_merchant ON food_offers(merchant_id);
CREATE INDEX idx_food_offers_status ON food_offers(status);
CREATE INDEX idx_food_offers_urgent ON food_offers(is_urgent) WHERE is_urgent = true;
CREATE INDEX idx_food_offers_available_date ON food_offers(available_date);
CREATE INDEX idx_orders_user ON orders(user_id);
CREATE INDEX idx_orders_merchant ON orders(merchant_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_reservations_user ON reservations(user_id);
CREATE INDEX idx_reservations_offer ON reservations(food_offer_id);
CREATE INDEX idx_stock_items_merchant ON stock_items(merchant_id);
CREATE INDEX idx_sales_merchant ON sales(merchant_id);
CREATE INDEX idx_sales_date ON sales(sale_date);

-- Index de recherche textuelle
CREATE INDEX idx_merchants_search ON merchants USING gin(
    to_tsvector('french', business_name || ' ' || COALESCE(description, ''))
);
CREATE INDEX idx_food_offers_search ON food_offers USING gin(
    to_tsvector('french', title || ' ' || COALESCE(description, ''))
);

-- ==============================================
-- ROW LEVEL SECURITY (RLS)
-- ==============================================

-- Activer RLS sur toutes les tables
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE merchants ENABLE ROW LEVEL SECURITY;
ALTER TABLE merchant_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE addresses ENABLE ROW LEVEL SECURITY;
ALTER TABLE food_offers ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE reservations ENABLE ROW LEVEL SECURITY;
ALTER TABLE stock_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE sales ENABLE ROW LEVEL SECURITY;
ALTER TABLE favorites ENABLE ROW LEVEL SECURITY;
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

-- Politiques pour les utilisateurs
CREATE POLICY "Users can view their own profile" ON users
    FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update their own profile" ON users
    FOR UPDATE USING (auth.uid() = id);

-- Politiques pour les marchands
CREATE POLICY "Public can view active merchants" ON merchants
    FOR SELECT USING (true);

CREATE POLICY "Merchants can update their own profile" ON merchants
    FOR UPDATE USING (auth.uid() = user_id);

-- Politiques pour les offres
CREATE POLICY "Public can view active offers" ON food_offers
    FOR SELECT USING (status = 'active');

CREATE POLICY "Merchants can manage their offers" ON food_offers
    FOR ALL USING (
        merchant_id IN (
            SELECT id FROM merchants WHERE user_id = auth.uid()
        )
    );

-- Politiques pour les commandes
CREATE POLICY "Users can view their own orders" ON orders
    FOR SELECT USING (user_id = auth.uid());

CREATE POLICY "Merchants can view their orders" ON orders
    FOR SELECT USING (
        merchant_id IN (
            SELECT id FROM merchants WHERE user_id = auth.uid()
        )
    );

-- Politiques pour les favoris
CREATE POLICY "Users can manage their favorites" ON favorites
    FOR ALL USING (user_id = auth.uid());

-- ==============================================
-- FONCTIONS ET TRIGGERS
-- ==============================================

-- Fonction pour mettre à jour updated_at
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Appliquer le trigger sur toutes les tables avec updated_at
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER update_merchants_updated_at BEFORE UPDATE ON merchants
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER update_merchant_profiles_updated_at BEFORE UPDATE ON merchant_profiles
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER update_food_offers_updated_at BEFORE UPDATE ON food_offers
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER update_orders_updated_at BEFORE UPDATE ON orders
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER update_reservations_updated_at BEFORE UPDATE ON reservations
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER update_stock_items_updated_at BEFORE UPDATE ON stock_items
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- Fonction pour générer un numéro de commande unique
CREATE OR REPLACE FUNCTION generate_order_number()
RETURNS TRIGGER AS $$
BEGIN
    NEW.order_number = 'ORD-' || TO_CHAR(NOW(), 'YYYYMMDD') || '-' || 
                       LPAD(nextval('order_number_seq')::TEXT, 6, '0');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Séquence pour les numéros de commande
CREATE SEQUENCE order_number_seq START 1;

-- Trigger pour générer automatiquement le numéro de commande
CREATE TRIGGER generate_order_number_trigger BEFORE INSERT ON orders
    FOR EACH ROW EXECUTE FUNCTION generate_order_number();

-- Fonction pour mettre à jour le stock après une vente
CREATE OR REPLACE FUNCTION update_stock_after_sale()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.stock_item_id IS NOT NULL THEN
        UPDATE stock_items 
        SET current_quantity = current_quantity - NEW.quantity
        WHERE id = NEW.stock_item_id;
        
        -- Mettre à jour le statut si nécessaire
        UPDATE stock_items
        SET status = CASE
            WHEN current_quantity <= 0 THEN 'out_of_stock'::stock_status
            WHEN current_quantity <= minimum_quantity THEN 'low_stock'::stock_status
            ELSE 'in_stock'::stock_status
        END
        WHERE id = NEW.stock_item_id;
    END IF;
    
    IF NEW.food_offer_id IS NOT NULL THEN
        UPDATE food_offers
        SET quantity_available = quantity_available - NEW.quantity,
            quantity_sold = quantity_sold + NEW.quantity
        WHERE id = NEW.food_offer_id;
        
        -- Mettre à jour le statut si nécessaire
        UPDATE food_offers
        SET status = CASE
            WHEN quantity_available <= 0 THEN 'sold_out'::offer_status
            ELSE status
        END
        WHERE id = NEW.food_offer_id;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger pour mettre à jour le stock
CREATE TRIGGER update_stock_trigger AFTER INSERT ON sale_items
    FOR EACH ROW EXECUTE FUNCTION update_stock_after_sale();

-- ==============================================
-- DONNÉES DE BASE
-- ==============================================

-- Insérer les catégories de base
INSERT INTO categories (name, slug, description, icon, display_order) VALUES
('Salades', 'salades', 'Salades fraîches et équilibrées', '🥗', 1),
('Sandwichs', 'sandwichs', 'Sandwichs et wraps', '🥪', 2),
('Plats chauds', 'plats-chauds', 'Plats cuisinés du jour', '🍲', 3),
('Desserts', 'desserts', 'Desserts et pâtisseries', '🍰', 4),
('Boissons', 'boissons', 'Boissons fraîches et chaudes', '🥤', 5),
('Viennoiseries', 'viennoiseries', 'Viennoiseries et pains', '🥐', 6),
('Fruits', 'fruits', 'Fruits frais et salades de fruits', '🍎', 7),
('Pâtes', 'pates', 'Pâtes fraîches et sauces', '🍝', 8),
('Pizzas', 'pizzas', 'Pizzas et calzones', '🍕', 9),
('Burgers', 'burgers', 'Burgers et frites', '🍔', 10),
('Tacos & Burritos', 'tacos-burritos', 'Cuisine mexicaine', '🌮', 11),
('Sushis', 'sushis', 'Sushis et makis', '🍱', 12),
('Wraps', 'wraps', 'Wraps et rouleaux', '🌯', 13),
('Soupes', 'soupes', 'Soupes et potages', '🍜', 14),
('Quiches & Tartes', 'quiches-tartes', 'Quiches et tartes salées', '🥧', 15),
('Snacks', 'snacks', 'Snacks et apéritifs', '🍿', 16),
('Petit-déjeuner', 'petit-dejeuner', 'Formules petit-déjeuner', '🥞', 17),
('Repas complets', 'repas-complets', 'Menus complets', '🍽️', 18),
('Cuisine du monde', 'cuisine-monde', 'Spécialités internationales', '🌍', 19),
('Halal', 'halal', 'Options halal certifiées', '☪️', 20),
('Casher', 'casher', 'Options casher', '✡️', 21),
('Sans gluten', 'sans-gluten', 'Options sans gluten', '🚫🌾', 22),
('Végétarien', 'vegetarien', 'Options végétariennes', '🌱', 23),
('Vegan', 'vegan', 'Options véganes', '🌿', 24),
('Bio', 'bio', 'Produits biologiques', '🌾', 25);