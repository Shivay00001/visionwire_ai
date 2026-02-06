// Subjects for each class level
const Map<String, List<String>> subjectsByClass = {
  'Class 1': ['English', 'Hindi', 'Mathematics', 'EVS'],
  'Class 2': ['English', 'Hindi', 'Mathematics', 'EVS'],
  'Class 3': ['English', 'Hindi', 'Mathematics', 'EVS'],
  'Class 4': ['English', 'Hindi', 'Mathematics', 'EVS'],
  'Class 5': ['English', 'Hindi', 'Mathematics', 'EVS'],
  'Class 6': ['English', 'Hindi', 'Mathematics', 'Science', 'Social Science'],
  'Class 7': ['English', 'Hindi', 'Mathematics', 'Science', 'Social Science'],
  'Class 8': ['English', 'Hindi', 'Mathematics', 'Science', 'Social Science'],
  'Class 9': ['English', 'Hindi', 'Mathematics', 'Science', 'Social Science'],
  'Class 10': ['English', 'Hindi', 'Mathematics', 'Science', 'Social Science'],
  'Class 11': ['Physics', 'Chemistry', 'Biology', 'Mathematics', 'English', 'Hindi', 'Computer Science', 'Accountancy', 'Economics', 'Business Studies'],
  'Class 12': ['Physics', 'Chemistry', 'Biology', 'Mathematics', 'English', 'Hindi', 'Computer Science', 'Accountancy', 'Economics', 'Business Studies'],
};

// Chapters for Science subjects (Class 11-12 for NEET/JEE)
const Map<String, List<String>> physicsChapters = {
  'Class 11': [
    'Physical World',
    'Units and Measurements',
    'Motion in a Straight Line',
    'Motion in a Plane',
    'Laws of Motion',
    'Work, Energy and Power',
    'System of Particles and Rotational Motion',
    'Gravitation',
    'Mechanical Properties of Solids',
    'Mechanical Properties of Fluids',
    'Thermal Properties of Matter',
    'Thermodynamics',
    'Kinetic Theory',
    'Oscillations',
    'Waves',
  ],
  'Class 12': [
    'Electric Charges and Fields',
    'Electrostatic Potential and Capacitance',
    'Current Electricity',
    'Moving Charges and Magnetism',
    'Magnetism and Matter',
    'Electromagnetic Induction',
    'Alternating Current',
    'Electromagnetic Waves',
    'Ray Optics and Optical Instruments',
    'Wave Optics',
    'Dual Nature of Radiation and Matter',
    'Atoms',
    'Nuclei',
    'Semiconductor Electronics',
  ],
};

const Map<String, List<String>> chemistryChapters = {
  'Class 11': [
    'Some Basic Concepts of Chemistry',
    'Structure of Atom',
    'Classification of Elements and Periodicity',
    'Chemical Bonding and Molecular Structure',
    'Thermodynamics',
    'Equilibrium',
    'Redox Reactions',
    'Organic Chemistry - Some Basic Principles',
    'Hydrocarbons',
    'Environmental Chemistry',
  ],
  'Class 12': [
    'Solid State',
    'Solutions',
    'Electrochemistry',
    'Chemical Kinetics',
    'Surface Chemistry',
    'General Principles of Isolation of Elements',
    'The p-Block Elements',
    'The d and f Block Elements',
    'Coordination Compounds',
    'Haloalkanes and Haloarenes',
    'Alcohols, Phenols and Ethers',
    'Aldehydes, Ketones and Carboxylic Acids',
    'Amines',
    'Biomolecules',
    'Polymers',
    'Chemistry in Everyday Life',
  ],
};

const Map<String, List<String>> biologyChapters = {
  'Class 11': [
    'The Living World',
    'Biological Classification',
    'Plant Kingdom',
    'Animal Kingdom',
    'Morphology of Flowering Plants',
    'Anatomy of Flowering Plants',
    'Structural Organisation in Animals',
    'Cell: The Unit of Life',
    'Biomolecules',
    'Cell Cycle and Cell Division',
    'Photosynthesis in Higher Plants',
    'Respiration in Plants',
    'Plant Growth and Development',
    'Breathing and Exchange of Gases',
    'Body Fluids and Circulation',
    'Excretory Products and their Elimination',
    'Locomotion and Movement',
    'Neural Control and Coordination',
    'Chemical Coordination and Integration',
  ],
  'Class 12': [
    'Reproduction in Organisms',
    'Sexual Reproduction in Flowering Plants',
    'Human Reproduction',
    'Reproductive Health',
    'Principles of Inheritance and Variation',
    'Molecular Basis of Inheritance',
    'Evolution',
    'Human Health and Disease',
    'Strategies for Enhancement in Food Production',
    'Microbes in Human Welfare',
    'Biotechnology: Principles and Processes',
    'Biotechnology and its Applications',
    'Organisms and Populations',
    'Ecosystem',
    'Biodiversity and Conservation',
    'Environmental Issues',
  ],
};

const Map<String, List<String>> mathematicsChapters = {
  'Class 11': [
    'Sets',
    'Relations and Functions',
    'Trigonometric Functions',
    'Complex Numbers and Quadratic Equations',
    'Linear Inequalities',
    'Permutations and Combinations',
    'Binomial Theorem',
    'Sequences and Series',
    'Straight Lines',
    'Conic Sections',
    'Introduction to Three Dimensional Geometry',
    'Limits and Derivatives',
    'Statistics',
    'Probability',
  ],
  'Class 12': [
    'Relations and Functions',
    'Inverse Trigonometric Functions',
    'Matrices',
    'Determinants',
    'Continuity and Differentiability',
    'Application of Derivatives',
    'Integrals',
    'Application of Integrals',
    'Differential Equations',
    'Vector Algebra',
    'Three Dimensional Geometry',
    'Linear Programming',
    'Probability',
  ],
};

// General Science chapters for Class 6-10
const Map<String, List<String>> scienceChapters = {
  'Class 6': ['Food: Where Does It Come From?', 'Components of Food', 'Fibre to Fabric', 'Sorting Materials', 'Separation of Substances', 'Changes Around Us', 'Getting to Know Plants', 'Body Movements', 'The Living Organisms', 'Motion and Measurement', 'Light, Shadows and Reflections', 'Electricity and Circuits', 'Fun with Magnets', 'Water', 'Air Around Us', 'Garbage In, Garbage Out'],
  'Class 7': ['Nutrition in Plants', 'Nutrition in Animals', 'Heat', 'Acids, Bases and Salts', 'Physical and Chemical Changes', 'Respiration in Organisms', 'Transportation in Animals and Plants', 'Reproduction in Plants', 'Motion and Time', 'Electric Current and Its Effects', 'Light', 'Water: A Precious Resource', 'Forests', 'Wastewater Story'],
  'Class 8': ['Crop Production and Management', 'Microorganisms', 'Coal and Petroleum', 'Combustion and Flame', 'Conservation of Plants and Animals', 'Reproduction in Animals', 'Reaching the Age of Adolescence', 'Force and Pressure', 'Friction', 'Sound', 'Chemical Effects of Electric Current', 'Some Natural Phenomena', 'Light', 'Stars and the Solar System', 'Pollution'],
  'Class 9': ['Matter in Our Surroundings', 'Is Matter Around Us Pure', 'Atoms and Molecules', 'Structure of the Atom', 'The Fundamental Unit of Life', 'Tissues', 'Motion', 'Force and Laws of Motion', 'Gravitation', 'Work and Energy', 'Sound', 'Improvement in Food Resources'],
  'Class 10': ['Chemical Reactions and Equations', 'Acids, Bases and Salts', 'Metals and Non-metals', 'Carbon and its Compounds', 'Life Processes', 'Control and Coordination', 'How do Organisms Reproduce', 'Heredity', 'Light - Reflection and Refraction', 'The Human Eye', 'Electricity', 'Magnetic Effects of Electric Current', 'Our Environment'],
};

// Function to get chapters based on class and subject
List<String> getChapters(String className, String subject) {
  if (subject == 'Physics' && physicsChapters.containsKey(className)) {
    return physicsChapters[className]!;
  }
  if (subject == 'Chemistry' && chemistryChapters.containsKey(className)) {
    return chemistryChapters[className]!;
  }
  if (subject == 'Biology' && biologyChapters.containsKey(className)) {
    return biologyChapters[className]!;
  }
  if (subject == 'Mathematics' && mathematicsChapters.containsKey(className)) {
    return mathematicsChapters[className]!;
  }
  if (subject == 'Science' && scienceChapters.containsKey(className)) {
    return scienceChapters[className]!;
  }
  // Default chapters for other subjects
  return ['Chapter 1', 'Chapter 2', 'Chapter 3', 'Chapter 4', 'Chapter 5'];
}
