import 'package:flutter/material.dart';
import '../../core/themes/tokens/deep_color_tokens.dart';
import '../../core/themes/deep_theme.dart';

class ThemeDemoPage extends StatefulWidget {
  const ThemeDemoPage({super.key});

  @override
  State<ThemeDemoPage> createState() => _ThemeDemoPageState();
}

class _ThemeDemoPageState extends State<ThemeDemoPage> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: isDarkMode ? DeepTheme.darkTheme : DeepTheme.lightTheme,
      child: Scaffold(
        backgroundColor: isDarkMode ? DeepColorTokens.neutral950 : DeepColorTokens.neutral50,
        body: CustomScrollView(
          slivers: [
            // AppBar avec gradient
            SliverAppBar(
              expandedHeight: 200,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text(
                  'Thème Profond Nyth',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black54,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: DeepColorTokens.primaryGradient,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.palette,
                          size: 60,
                          color: DeepColorTokens.neutral0.withValues(alpha: 0.8),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Confiance • Stabilité • Professionnalisme',
                          style: TextStyle(
                            color: DeepColorTokens.neutral0.withValues(alpha: 0.9),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
                  onPressed: () {
                    setState(() {
                      isDarkMode = !isDarkMode;
                    });
                  },
                  tooltip: isDarkMode ? 'Mode clair' : 'Mode sombre',
                ),
              ],
            ),

            // Contenu principal
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Section Couleurs Principales
                  _buildSectionTitle('Couleurs Principales'),
                  const SizedBox(height: 16),
                  _buildColorShowcase(),
                  const SizedBox(height: 32),

                  // Section Boutons
                  _buildSectionTitle('Boutons et Actions'),
                  const SizedBox(height: 16),
                  _buildButtonsSection(),
                  const SizedBox(height: 32),

                  // Section Cartes Premium
                  _buildSectionTitle('Cartes et Containers'),
                  const SizedBox(height: 16),
                  _buildCardsSection(),
                  const SizedBox(height: 32),

                  // Section Badges
                  _buildSectionTitle('Badges et États'),
                  const SizedBox(height: 16),
                  _buildBadgesSection(),
                  const SizedBox(height: 32),

                  // Section Formulaires
                  _buildSectionTitle('Champs de formulaire'),
                  const SizedBox(height: 16),
                  _buildFormSection(),
                  const SizedBox(height: 32),

                  // Section Gradients
                  _buildSectionTitle('Gradients Premium'),
                  const SizedBox(height: 16),
                  _buildGradientsSection(),
                  const SizedBox(height: 32),

                  // Section Stats
                  _buildSectionTitle('Statistiques et Données'),
                  const SizedBox(height: 16),
                  _buildStatsSection(),
                  const SizedBox(height: 100),
                ]),
              ),
            ),
          ],
        ),

        // Bottom Navigation
        bottomNavigationBar: _buildBottomNavigation(),

        // FAB
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {},
          backgroundColor: DeepColorTokens.accent,
          icon: const Icon(Icons.star),
          label: const Text('Premium'),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: isDarkMode ? DeepColorTokens.neutral100 : DeepColorTokens.neutral900,
      ),
    );
  }

  Widget _buildColorShowcase() {
    return Row(
      children: [
        Expanded(child: _buildColorCard('Primaire', DeepColorTokens.primary)),
        const SizedBox(width: 12),
        Expanded(child: _buildColorCard('Secondaire', DeepColorTokens.secondary)),
        const SizedBox(width: 12),
        Expanded(child: _buildColorCard('Tertiaire', DeepColorTokens.tertiary)),
        const SizedBox(width: 12),
        Expanded(child: _buildColorCard('Accent', DeepColorTokens.accent)),
      ],
    );
  }

  Widget _buildColorCard(String name, Color color) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.circle,
              color: DeepColorTokens.neutral0,
              size: 30,
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: TextStyle(
                color: DeepColorTokens.neutral0,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonsSection() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: DeepColorTokens.primary,
            foregroundColor: DeepColorTokens.neutral0,
          ),
          child: const Text('Principal'),
        ),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: DeepColorTokens.secondary,
            foregroundColor: DeepColorTokens.neutral0,
          ),
          child: const Text('Secondaire'),
        ),
        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            foregroundColor: DeepColorTokens.primary,
            side: BorderSide(color: DeepColorTokens.primary, width: 2),
          ),
          child: const Text('Contour'),
        ),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            foregroundColor: DeepColorTokens.tertiary,
          ),
          child: const Text('Texte'),
        ),
        ElevatedButton.icon(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: DeepColorTokens.premium,
            foregroundColor: DeepColorTokens.neutral0,
          ),
          icon: const Icon(Icons.diamond),
          label: const Text('Premium'),
        ),
        ElevatedButton(
          onPressed: null,
          style: ElevatedButton.styleFrom(
            backgroundColor: DeepColorTokens.neutral400,
          ),
          child: const Text('Désactivé'),
        ),
      ],
    );
  }

  Widget _buildCardsSection() {
    return Column(
      children: [
        // Carte avec gradient de confiance
        Container(
          decoration: BoxDecoration(
            gradient: DeepColorTokens.confidenceGradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: DeepColorTokens.shadowMedium,
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Icon(
                Icons.security,
                color: DeepColorTokens.neutral0,
                size: 48,
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sécurité Maximale',
                      style: TextStyle(
                        color: DeepColorTokens.neutral0,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Vos données sont protégées avec les standards les plus élevés',
                      style: TextStyle(
                        color: DeepColorTokens.neutral0.withValues(alpha: 0.9),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Carte premium
        Container(
          decoration: BoxDecoration(
            gradient: DeepColorTokens.premiumGradient,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: DeepColorTokens.accentLight,
            ),
          ),
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: DeepColorTokens.accent,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.workspace_premium,
                  color: DeepColorTokens.neutral0,
                  size: 32,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Accès Premium',
                      style: TextStyle(
                        color: DeepColorTokens.neutral0,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Débloquez toutes les fonctionnalités avancées',
                      style: TextStyle(
                        color: DeepColorTokens.neutral0.withValues(alpha: 0.9),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Carte simple avec surface élevée
        Card(
          color: isDarkMode ? DeepColorTokens.surfaceElevated : DeepColorTokens.neutral0,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isDarkMode ? DeepColorTokens.neutral800 : DeepColorTokens.neutral200,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.insights,
                      color: DeepColorTokens.tertiary,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Analyses Approfondies',
                      style: TextStyle(
                        color: isDarkMode ? DeepColorTokens.neutral100 : DeepColorTokens.neutral900,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  "Obtenez des insights détaillés sur vos performances avec nos outils d'analyse avancés.",
                  style: TextStyle(
                    color: isDarkMode ? DeepColorTokens.neutral400 : DeepColorTokens.neutral600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBadgesSection() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _buildBadge('URGENT', DeepColorTokens.urgent),
        _buildBadge('NOUVEAU', DeepColorTokens.new_),
        _buildBadge('PREMIUM', DeepColorTokens.premium),
        _buildBadge('EXCLUSIF', DeepColorTokens.exclusive),
        _buildBadge('SPÉCIAL', DeepColorTokens.special),
        _buildBadge('SUCCÈS', DeepColorTokens.success),
        _buildBadge('ATTENTION', DeepColorTokens.warning),
        _buildBadge('ERREUR', DeepColorTokens.error),
        _buildBadge('INFO', DeepColorTokens.info),
        _buildBadge('PRO', DeepColorTokens.professional),
      ],
    );
  }

  Widget _buildBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        label,
        style: TextStyle(
          color: DeepColorTokens.neutral0,
          fontWeight: FontWeight.bold,
          fontSize: 12,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildFormSection() {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            labelText: 'Email',
            hintText: 'votre@email.com',
            prefixIcon: Icon(Icons.email, color: DeepColorTokens.primary),
            filled: true,
            fillColor: isDarkMode ? DeepColorTokens.surfaceContainer : DeepColorTokens.neutral50,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDarkMode ? DeepColorTokens.neutral700 : DeepColorTokens.neutral300,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: DeepColorTokens.primary,
                width: 2,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Mot de passe',
            hintText: '••••••••',
            prefixIcon: Icon(Icons.lock, color: DeepColorTokens.primary),
            suffixIcon: Icon(Icons.visibility, color: DeepColorTokens.neutral500),
            filled: true,
            fillColor: isDarkMode ? DeepColorTokens.surfaceContainer : DeepColorTokens.neutral50,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDarkMode ? DeepColorTokens.neutral700 : DeepColorTokens.neutral300,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: DeepColorTokens.primary,
                width: 2,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Checkbox(
              value: true,
              onChanged: (value) {},
              activeColor: DeepColorTokens.primary,
            ),
            Text(
              'Se souvenir de moi',
              style: TextStyle(
                color: isDarkMode ? DeepColorTokens.neutral300 : DeepColorTokens.neutral700,
              ),
            ),
            const Spacer(),
            Switch(
              value: true,
              onChanged: (value) {},
              activeThumbColor: DeepColorTokens.tertiary,
            ),
            Text(
              'Notifications',
              style: TextStyle(
                color: isDarkMode ? DeepColorTokens.neutral300 : DeepColorTokens.neutral700,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGradientsSection() {
    return Column(
      children: [
        _buildGradientCard(
          'Gradient Principal',
          DeepColorTokens.primaryGradient,
          Icons.trending_up,
        ),
        const SizedBox(height: 12),
        _buildGradientCard(
          'Gradient Premium',
          DeepColorTokens.premiumGradient,
          Icons.diamond,
        ),
        const SizedBox(height: 12),
        _buildGradientCard(
          'Gradient Confiance',
          DeepColorTokens.confidenceGradient,
          Icons.verified_user,
        ),
        const SizedBox(height: 12),
        _buildGradientCard(
          'Surface Sombre',
          DeepColorTokens.darkSurfaceGradient,
          Icons.dark_mode,
        ),
      ],
    );
  }

  Widget _buildGradientCard(String title, Gradient gradient, IconData icon) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: DeepColorTokens.shadowMedium,
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: DeepColorTokens.neutral0,
              size: 32,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                color: DeepColorTokens.neutral0,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? DeepColorTokens.surfaceElevated : DeepColorTokens.neutral0,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? DeepColorTokens.neutral800 : DeepColorTokens.neutral200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performance du mois',
            style: TextStyle(
              color: isDarkMode ? DeepColorTokens.neutral100 : DeepColorTokens.neutral900,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Revenue', '€12,450', DeepColorTokens.success, Icons.trending_up),
              _buildStatItem('Clients', '1,234', DeepColorTokens.primary, Icons.people),
              _buildStatItem('Croissance', '+24%', DeepColorTokens.tertiary, Icons.show_chart),
            ],
          ),
          const SizedBox(height: 20),
          LinearProgressIndicator(
            value: 0.75,
            backgroundColor: isDarkMode ? DeepColorTokens.neutral700 : DeepColorTokens.neutral300,
            valueColor: AlwaysStoppedAnimation<Color>(DeepColorTokens.primary),
            minHeight: 8,
          ),
          const SizedBox(height: 8),
          Text(
            "75% de l'objectif atteint",
            style: TextStyle(
              color: isDarkMode ? DeepColorTokens.neutral400 : DeepColorTokens.neutral600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: isDarkMode ? DeepColorTokens.neutral100 : DeepColorTokens.neutral900,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: isDarkMode ? DeepColorTokens.neutral400 : DeepColorTokens.neutral600,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigation() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: isDarkMode ? DeepColorTokens.surfaceElevated : DeepColorTokens.neutral0,
      selectedItemColor: DeepColorTokens.primary,
      unselectedItemColor: isDarkMode ? DeepColorTokens.neutral500 : DeepColorTokens.neutral600,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Accueil',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.explore),
          label: 'Explorer',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_outline),
          label: 'Créer',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'Alertes',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profil',
        ),
      ],
    );
  }
}