import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../core/responsive/responsive.dart';
import '../../core/themes/deep_theme.dart';
import '../../core/themes/tokens/deep_color_tokens.dart';
import '../../domain/entities/food_offer.dart';

class ProductDetailPage extends ConsumerStatefulWidget {
  final String offerId;

  const ProductDetailPage({
    super.key,
    required this.offerId,
  });

  @override
  ConsumerState<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends ConsumerState<ProductDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isFavorite = false;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobile: (_) => _buildMobileLayout(context),
        tablet: (_) => _buildTabletLayout(context),
        desktop: (_) => _buildDesktopLayout(context),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Image Hero avec App Bar transparent
        _buildSliverAppBar(context),

        // Contenu principal
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProductHeader(context),
              _buildPriceSection(context),
              _buildMerchantSection(context),
              _buildDescriptionSection(context),
              _buildNutritionalInfo(context),
              _buildAvailabilitySection(context),
              _buildRelatedProducts(context),
              SizedBox(height: 100), // Espace pour le bouton fixe
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return Row(
      children: [
        // Image fixe à gauche
        Expanded(
          flex: 2,
          child: _buildProductImages(context),
        ),
        // Détails à droite avec scroll
        Expanded(
          flex: 3,
          child: Column(
            children: [
              _buildSimpleAppBar(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(context.horizontalSpacing * 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProductHeader(context),
                      _buildPriceSection(context),
                      _buildMerchantSection(context),
                      _buildDescriptionSection(context),
                      _buildNutritionalInfo(context),
                      _buildAvailabilitySection(context),
                      _buildRelatedProducts(context),
                    ],
                  ),
                ),
              ),
              _buildBottomBar(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Column(
      children: [
        _buildSimpleAppBar(context),
        Expanded(
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Images à gauche
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.all(context.horizontalSpacing * 2),
                      child: _buildProductImages(context),
                    ),
                  ),
                  // Détails à droite
                  Expanded(
                    flex: 3,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(context.horizontalSpacing * 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildProductHeader(context),
                          _buildPriceSection(context),
                          _buildMerchantSection(context),
                          _buildDescriptionSection(context),
                          _buildNutritionalInfo(context),
                          _buildAvailabilitySection(context),
                          _buildRelatedProducts(context),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: DeepColorTokens.surface,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Image principale
            CachedNetworkImage(
              imageUrl:
                  'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=800',
              fit: BoxFit.cover,
            ),
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.3),
                  ],
                ),
              ),
            ),
            // Badge de réduction
            Positioned(
              top: 16,
              right: 16,
              child: SafeArea(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.horizontalSpacing,
                    vertical: context.verticalSpacing / 2,
                  ),
                  decoration: BoxDecoration(
                    color: DeepColorTokens.error,
                    borderRadius: BorderRadius.circular(context.borderRadius),
                  ),
                  child: Text(
                    '-40%',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: FontSizes.titleMedium.getSize(context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      leading: SafeArea(
        child: Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: DeepColorTokens.surface.withValues(alpha: 0.9),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: DeepColorTokens.textPrimary),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      actions: [
        SafeArea(
          child: Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: DeepColorTokens.surface.withValues(alpha: 0.9),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                _isFavorite ? Icons.favorite : Icons.favorite_border,
                color: _isFavorite
                    ? DeepColorTokens.error
                    : DeepColorTokens.textPrimary,
              ),
              onPressed: () {
                setState(() => _isFavorite = !_isFavorite);
              },
            ),
          ),
        ),
        SafeArea(
          child: Container(
            margin: EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: DeepColorTokens.surface.withValues(alpha: 0.9),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.share, color: DeepColorTokens.textPrimary),
              onPressed: () {
                // Partager
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSimpleAppBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.horizontalSpacing),
      decoration: BoxDecoration(
        color: DeepColorTokens.surface,
        border: Border(
          bottom: BorderSide(
            color: DeepColorTokens.divider,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Spacer(),
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? DeepColorTokens.error : null,
            ),
            onPressed: () {
              setState(() => _isFavorite = !_isFavorite);
            },
          ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              // Partager
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProductImages(BuildContext context) {
    final images = [
      'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=800',
      'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=800',
      'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800',
    ];

    return Column(
      children: [
        // Image principale
        AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(context.borderRadius * 2),
              image: DecorationImage(
                image: CachedNetworkImageProvider(images[0]),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        SizedBox(height: context.verticalSpacing),
        // Thumbnails
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: images.length,
            itemBuilder: (context, index) {
              return Container(
                width: 80,
                height: 80,
                margin: EdgeInsets.only(right: context.horizontalSpacing),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(context.borderRadius),
                  border: Border.all(
                    color: index == 0
                        ? DeepColorTokens.primary
                        : DeepColorTokens.divider,
                    width: 2,
                  ),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(images[index]),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProductHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(context.horizontalSpacing * 1.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badge urgence
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: context.horizontalSpacing,
              vertical: context.verticalSpacing / 2,
            ),
            decoration: BoxDecoration(
              color: DeepColorTokens.warning.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(context.borderRadius / 2),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.local_fire_department,
                  size: 16,
                  color: DeepColorTokens.warning,
                ),
                SizedBox(width: 4),
                Text(
                  'Offre urgente - À consommer aujourd\'hui',
                  style: TextStyle(
                    fontSize: FontSizes.bodySmall.getSize(context),
                    color: DeepColorTokens.warning,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: context.verticalSpacing),

          // Titre
          Text(
            'Salade Caesar Premium',
            style: TextStyle(
              fontSize: FontSizes.titleSmall.getSize(context),
              fontWeight: FontWeight.bold,
              color: DeepColorTokens.textPrimary,
            ),
          ),
          SizedBox(height: context.verticalSpacing / 2),

          // Tags
          Wrap(
            spacing: context.horizontalSpacing / 2,
            children: [
              _buildTag('Bio', Icons.eco, DeepColorTokens.success),
              _buildTag('Sans gluten', Icons.no_meals, DeepColorTokens.info),
              _buildTag('Végétarien', Icons.spa, DeepColorTokens.success),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String label, IconData icon, Color color) {
    return Chip(
      avatar: Icon(icon, size: 16, color: color),
      label: Text(
        label,
        style: TextStyle(
          fontSize: FontSizes.caption.getSize(context),
          color: color,
        ),
      ),
      backgroundColor: color.withValues(alpha: 0.1),
      side: BorderSide.none,
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Widget _buildPriceSection(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: context.horizontalSpacing * 1.5),
      padding: EdgeInsets.all(context.horizontalSpacing * 1.5),
      decoration: BoxDecoration(
        color: DeepColorTokens.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(context.borderRadius * 1.5),
        border: Border.all(
          color: DeepColorTokens.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '5,99 €',
                    style: TextStyle(
                      fontSize: FontSizes.titleLarge.getSize(context),
                      fontWeight: FontWeight.bold,
                      color: DeepColorTokens.primary,
                    ),
                  ),
                  SizedBox(width: context.horizontalSpacing),
                  Text(
                    '9,99 €',
                    style: TextStyle(
                      fontSize: FontSizes.bodyLarge.getSize(context),
                      color: DeepColorTokens.textTertiary,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ),
              SizedBox(height: context.verticalSpacing / 2),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.horizontalSpacing / 2,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: DeepColorTokens.success,
                  borderRadius: BorderRadius.circular(context.borderRadius / 2),
                ),
                child: Text(
                  'Vous économisez 4,00 €',
                  style: TextStyle(
                    fontSize: FontSizes.caption.getSize(context),
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          Spacer(),
          // Sélecteur de quantité
          Container(
            decoration: BoxDecoration(
              color: DeepColorTokens.surface,
              borderRadius: BorderRadius.circular(context.borderRadius),
              border: Border.all(
                color: DeepColorTokens.divider,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.remove, size: 20),
                  onPressed: _quantity > 1
                      ? () => setState(() => _quantity--)
                      : null,
                ),
                Container(
                  constraints: BoxConstraints(minWidth: 40),
                  child: Text(
                    '$_quantity',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: FontSizes.bodyLarge.getSize(context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add, size: 20),
                  onPressed: _quantity < 5
                      ? () => setState(() => _quantity++)
                      : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMerchantSection(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(context.horizontalSpacing * 1.5),
      padding: EdgeInsets.all(context.horizontalSpacing * 1.5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            DeepColorTokens.primary.withValues(alpha: 0.03),
            DeepColorTokens.primary.withValues(alpha: 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(context.borderRadius * 1.5),
        border: Border.all(
          color: DeepColorTokens.primary.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Logo boutique
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(context.borderRadius),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(
                      'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=400',
                    ),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
              SizedBox(width: context.horizontalSpacing),

              // Infos boutique
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Boulangerie Paul',
                      style: TextStyle(
                        fontSize: FontSizes.titleMedium.getSize(context),
                        fontWeight: FontWeight.bold,
                        color: DeepColorTokens.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 16,
                          color: DeepColorTokens.warning,
                        ),
                        SizedBox(width: 4),
                        Text(
                          '4.8',
                          style: TextStyle(
                            fontSize: FontSizes.bodySmall.getSize(context),
                            fontWeight: FontWeight.w600,
                            color: DeepColorTokens.textPrimary,
                          ),
                        ),
                        Text(
                          ' (234 avis)',
                          style: TextStyle(
                            fontSize: FontSizes.bodySmall.getSize(context),
                            color: DeepColorTokens.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 14,
                          color: DeepColorTokens.textSecondary,
                        ),
                        SizedBox(width: 4),
                        Text(
                          '500m · 5 rue de la Paix',
                          style: TextStyle(
                            fontSize: FontSizes.caption.getSize(context),
                            color: DeepColorTokens.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Bouton visiter
              OutlinedButton.icon(
                onPressed: () {
                  // Navigation vers la boutique
                },
                icon: Icon(Icons.store, size: 16),
                label: Text('Visiter'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: DeepColorTokens.primary,
                  side: BorderSide(
                    color: DeepColorTokens.primary,
                    width: 1,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: context.horizontalSpacing,
                    vertical: context.verticalSpacing / 2,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: context.verticalSpacing),
          Divider(color: DeepColorTokens.divider),
          SizedBox(height: context.verticalSpacing),

          // Stats de la boutique
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMerchantStat(
                icon: Icons.eco,
                value: '2,3k',
                label: 'Repas sauvés',
                color: DeepColorTokens.success,
              ),
              _buildMerchantStat(
                icon: Icons.timer,
                value: '15min',
                label: 'Temps moyen',
                color: DeepColorTokens.info,
              ),
              _buildMerchantStat(
                icon: Icons.verified,
                value: '98%',
                label: 'Satisfaction',
                color: DeepColorTokens.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMerchantStat({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(context.horizontalSpacing / 2),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 20,
            color: color,
          ),
        ),
        SizedBox(height: context.verticalSpacing / 2),
        Text(
          value,
          style: TextStyle(
            fontSize: FontSizes.bodyMedium.getSize(context),
            fontWeight: FontWeight.bold,
            color: DeepColorTokens.textPrimary,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: FontSizes.caption.getSize(context),
            color: DeepColorTokens.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(context.horizontalSpacing * 1.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: TextStyle(
              fontSize: FontSizes.titleMedium.getSize(context),
              fontWeight: FontWeight.bold,
              color: DeepColorTokens.textPrimary,
            ),
          ),
          SizedBox(height: context.verticalSpacing),
          Text(
            'Une délicieuse salade Caesar préparée avec des ingrédients frais et bio : '
            'laitue romaine croquante, parmesan AOP, croûtons maison, et notre fameuse '
            'sauce Caesar légère. Parfait pour un déjeuner sain et équilibré.',
            style: TextStyle(
              fontSize: FontSizes.bodyMedium.getSize(context),
              color: DeepColorTokens.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionalInfo(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: context.horizontalSpacing * 1.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informations nutritionnelles',
            style: TextStyle(
              fontSize: FontSizes.titleMedium.getSize(context),
              fontWeight: FontWeight.bold,
              color: DeepColorTokens.textPrimary,
            ),
          ),
          SizedBox(height: context.verticalSpacing),
          Container(
            padding: EdgeInsets.all(context.horizontalSpacing),
            decoration: BoxDecoration(
              color: DeepColorTokens.neutral100,
              borderRadius: BorderRadius.circular(context.borderRadius),
            ),
            child: Column(
              children: [
                _buildNutritionRow('Calories', '320 kcal'),
                _buildNutritionRow('Protéines', '24g'),
                _buildNutritionRow('Glucides', '15g'),
                _buildNutritionRow('Lipides', '18g'),
                _buildNutritionRow('Fibres', '5g'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.verticalSpacing / 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: FontSizes.bodySmall.getSize(context),
              color: DeepColorTokens.textSecondary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: FontSizes.bodySmall.getSize(context),
              fontWeight: FontWeight.w600,
              color: DeepColorTokens.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailabilitySection(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(context.horizontalSpacing * 1.5),
      padding: EdgeInsets.all(context.horizontalSpacing * 1.5),
      decoration: BoxDecoration(
        color: DeepColorTokens.info.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(context.borderRadius),
        border: Border.all(
          color: DeepColorTokens.info.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 20,
                color: DeepColorTokens.info,
              ),
              SizedBox(width: context.horizontalSpacing / 2),
              Text(
                'Horaires de collecte',
                style: TextStyle(
                  fontSize: FontSizes.bodyMedium.getSize(context),
                  fontWeight: FontWeight.bold,
                  color: DeepColorTokens.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: context.verticalSpacing),
          Text(
            'Aujourd\'hui : 18h30 - 20h00',
            style: TextStyle(
              fontSize: FontSizes.bodyMedium.getSize(context),
              color: DeepColorTokens.textPrimary,
            ),
          ),
          SizedBox(height: context.verticalSpacing / 2),
          LinearProgressIndicator(
            value: 0.3,
            backgroundColor: DeepColorTokens.neutral200,
            valueColor: AlwaysStoppedAnimation<Color>(DeepColorTokens.success),
          ),
          SizedBox(height: context.verticalSpacing / 2),
          Text(
            'Plus que 3 disponibles sur 10',
            style: TextStyle(
              fontSize: FontSizes.caption.getSize(context),
              color: DeepColorTokens.warning,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedProducts(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(context.horizontalSpacing * 1.5),
          child: Text(
            'Autres offres de cette boutique',
            style: TextStyle(
              fontSize: FontSizes.titleMedium.getSize(context),
              fontWeight: FontWeight.bold,
              color: DeepColorTokens.textPrimary,
            ),
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(
              horizontal: context.horizontalSpacing,
            ),
            itemCount: 5,
            itemBuilder: (context, index) {
              return _buildRelatedProductCard(context);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRelatedProductCard(BuildContext context) {
    return Container(
      width: 150,
      margin: EdgeInsets.only(right: context.horizontalSpacing),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.borderRadius),
          side: BorderSide(
            color: DeepColorTokens.divider,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(context.borderRadius),
                ),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(
                    'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(context.horizontalSpacing),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bowl Végétarien',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: FontSizes.bodySmall.getSize(context),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '4,99 €',
                        style: TextStyle(
                          fontSize: FontSizes.bodySmall.getSize(context),
                          color: DeepColorTokens.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 4),
                      Text(
                        '7,99 €',
                        style: TextStyle(
                          fontSize: FontSizes.caption.getSize(context),
                          color: DeepColorTokens.textTertiary,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.horizontalSpacing * 1.5),
      decoration: BoxDecoration(
        color: DeepColorTokens.surface,
        border: Border(
          top: BorderSide(
            color: DeepColorTokens.divider,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Total',
                  style: TextStyle(
                    fontSize: FontSizes.caption.getSize(context),
                    color: DeepColorTokens.textSecondary,
                  ),
                ),
                Text(
                  '${(5.99 * _quantity).toStringAsFixed(2)} €',
                  style: TextStyle(
                    fontSize: FontSizes.titleLarge.getSize(context),
                    fontWeight: FontWeight.bold,
                    color: DeepColorTokens.primary,
                  ),
                ),
              ],
            ),
            SizedBox(width: context.horizontalSpacing * 2),
            Expanded(
              child: FilledButton.icon(
                onPressed: () {
                  // Réserver
                },
                icon: Icon(Icons.shopping_cart),
                label: Text('Réserver maintenant'),
                style: FilledButton.styleFrom(
                  backgroundColor: DeepColorTokens.primary,
                  padding: EdgeInsets.symmetric(
                    vertical: context.verticalSpacing * 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Bottom sheet fixe pour mobile
class _MobileBottomSheet extends StatelessWidget {
  final int quantity;
  final VoidCallback onReserve;

  const _MobileBottomSheet({
    required this.quantity,
    required this.onReserve,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.horizontalSpacing * 1.5),
      decoration: BoxDecoration(
        color: DeepColorTokens.surface,
        border: Border(
          top: BorderSide(
            color: DeepColorTokens.divider,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Total',
                  style: TextStyle(
                    fontSize: FontSizes.caption.getSize(context),
                    color: DeepColorTokens.textSecondary,
                  ),
                ),
                Text(
                  '${(5.99 * quantity).toStringAsFixed(2)} €',
                  style: TextStyle(
                    fontSize: FontSizes.titleLarge.getSize(context),
                    fontWeight: FontWeight.bold,
                    color: DeepColorTokens.primary,
                  ),
                ),
              ],
            ),
            SizedBox(width: context.horizontalSpacing * 2),
            Expanded(
              child: FilledButton.icon(
                onPressed: onReserve,
                icon: Icon(Icons.shopping_cart),
                label: Text('Réserver'),
                style: FilledButton.styleFrom(
                  backgroundColor: DeepColorTokens.primary,
                  padding: EdgeInsets.symmetric(
                    vertical: context.verticalSpacing * 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
