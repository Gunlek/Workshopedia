class Machine {

  final int id;
  final String title;
  final int category;
  final String brand;
  final String image;
  final String reference;

  Machine({this.id, this.title, this.category, this.brand, this.image, this.reference});

}

final milling_machine = [
  Machine(
    id: 0,
    category: 0,
    title: "5 axes",
    brand: "Lemoine",
    reference: "Reference",
    image: "assets/images/lemoine_illustration.jpg"
  ),

  Machine(
    id: 1,
    category: 0,
    title: "VF-1",
    brand: "Haas",
    reference: "Reference",
    image: "assets/images/haas_illustration.jpg"
  ),

  Machine(
    id: 2,
    category: 0,
    title: "VR-8",
    brand: "Haas",
    reference: "Reference",
    image: "assets/images/haas_illustration.jpg"
  ),
];

final turning_machine = [
  Machine(
    id: 3,
    category: 1,
    title: "Tour",
    brand: "Ernault Somua",
    reference: "Reference",
    image: "assets/images/ernault_somua_illustration.jpg"
  ),

  Machine(
    id: 4,
    category: 1,
    title: "Tour",
    brand: "Cazeneuve",
    reference: "Reference",
    image: "assets/images/cazeneuve_illustration.jpg"
  ),
];

final boring_machine = [
  Machine(
    id: 5,
    category: 2,
    title: "Perceuse à colonne",
    brand: "Inconnue",
    reference: "Reference",
    image: "assets/images/perceuse_colonne_illustration.jpg"
  ),

  Machine(
    id: 6,
    category: 2,
    title: "Perceuse à colonne",
    brand: "Inconnue",
    reference: "Reference",
    image: "assets/images/perceuse_2_illustration.jpg"
  )
];

final machines = milling_machine + turning_machine + boring_machine;