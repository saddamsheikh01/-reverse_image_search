enum SearchType {
  all('all'),
  visualMatches('visual_matches'),
  exactMatches('exact_matches'),
  products('products'),
  aboutThisImage('about_this_image');

  const SearchType(this.apiValue);
  final String apiValue;

  static SearchType fromValue(String? value) {
    return SearchType.values.firstWhere(
      (item) => item.apiValue == value,
      orElse: () => SearchType.all,
    );
  }
}

enum PremiumFeature {
  exactMatches,
  productSearch,
  advancedFilters,
  unlimitedSearch,
  adFree,
  favorites,
}
