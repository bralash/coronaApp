class Countries {
    String alpha3code;
    String name;

    Countries(this.alpha3code,this.name);

    static List<Countries> getCountries() {
      return <Countries>[
        Countries('AFG', 'Afghanistan'),
        Countries('ALA', 'Åland Islands'),
        Countries('ALB', 'Albania'),
      ];
    }
  }