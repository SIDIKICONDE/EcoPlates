/// Utilitaires pour les calculs écologiques dans EcoPlates
class EcoCalculations {
  /// Calcule le nombre d'arbres équivalent à la quantité de CO2 économisée
  /// Un arbre absorbe environ 22 kg de CO2 par an
  static String calculateTreesEquivalent(double co2Saved) {
    final trees = (co2Saved / 22).round();
    return trees.toString();
  }

  /// Calcule les déchets évités en grammes
  /// Estimation : une assiette jetable = ~15g de plastique évité
  static String calculateWasteAvoided(int platesUsed) {
    final wasteAvoided = platesUsed * 15;
    if (wasteAvoided > 1000) {
      return '${(wasteAvoided / 1000).toStringAsFixed(1)}k';
    }
    return wasteAvoided.toString();
  }

  /// Retourne un conseil écologique basé sur le nombre d'assiettes utilisées
  static String getEcoTip(int platesUsed) {
    if (platesUsed < 5) {
      return 'Continuez à utiliser EcoPlates pour réduire votre empreinte carbone !';
    } else if (platesUsed < 20) {
      return "Excellent ! Partagez EcoPlates avec vos amis pour multiplier l'impact.";
    } else if (platesUsed < 50) {
      return "Bravo ! Vous êtes un vrai ambassadeur de l'écologie.";
    } else {
      return 'Incroyable ! Votre engagement fait vraiment la différence.';
    }
  }
}
