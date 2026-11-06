import 'dart:math';
import '../models/question_model.dart';

class AiEnglishGeneratorService {
  static const List<String> _studentNames = [
    'Syalumi', 'Sinan', 'Budi', 'Ani', 'Siti', 'Edo', 'Dayu', 'Rani', 'Lani', 'Made', 'Dito', 'Udin'
  ];

  static const List<Map<String, String>> _vocabPool = [
    {'en': 'Apple', 'id': 'Apel', 'emoji': '🍎', 'category': 'Fruit'},
    {'en': 'Banana', 'id': 'Pisang', 'emoji': '🍌', 'category': 'Fruit'},
    {'en': 'Orange', 'id': 'Jeruk', 'emoji': '🍊', 'category': 'Fruit'},
    {'en': 'Watermelon', 'id': 'Semangka', 'emoji': '🍉', 'category': 'Fruit'},
    {'en': 'Mango', 'id': 'Mangga', 'emoji': '🥭', 'category': 'Fruit'},
    {'en': 'Cat', 'id': 'Kucing', 'emoji': '🐱', 'category': 'Animal'},
    {'en': 'Dog', 'id': 'Anjing', 'emoji': '🐶', 'category': 'Animal'},
    {'en': 'Rabbit', 'id': 'Kelinci', 'emoji': '🐰', 'category': 'Animal'},
    {'en': 'Elephant', 'id': 'Gajah', 'emoji': '🐘', 'category': 'Animal'},
    {'en': 'Lion', 'id': 'Singa', 'emoji': '🦁', 'category': 'Animal'},
    {'en': 'Tiger', 'id': 'Harimau', 'emoji': '🐯', 'category': 'Animal'},
    {'en': 'Fish', 'id': 'Ikan', 'emoji': '🐟', 'category': 'Animal'},
    {'en': 'Bird', 'id': 'Burung', 'emoji': '🐦', 'category': 'Animal'},
    {'en': 'Pencil', 'id': 'Pensil', 'emoji': '✏️', 'category': 'School'},
    {'en': 'Book', 'id': 'Buku', 'emoji': '📚', 'category': 'School'},
    {'en': 'Bag', 'id': 'Tas', 'emoji': '🎒', 'category': 'School'},
    {'en': 'Eraser', 'id': 'Penghapus', 'emoji': '🧹', 'category': 'School'},
    {'en': 'Ruler', 'id': 'Penggaris', 'emoji': '📏', 'category': 'School'},
    {'en': 'Car', 'id': 'Mobil', 'emoji': '🚗', 'category': 'Vehicle'},
    {'en': 'Bicycle', 'id': 'Sepeda', 'emoji': '🚲', 'category': 'Vehicle'},
    {'en': 'Airplane', 'id': 'Pesawat', 'emoji': '✈️', 'category': 'Vehicle'},
    {'en': 'Train', 'id': 'Kereta', 'emoji': '🚂', 'category': 'Vehicle'},
    {'en': 'Kitchen', 'id': 'Dapur', 'emoji': '🍳', 'category': 'House'},
    {'en': 'Bedroom', 'id': 'Kamar Tidur', 'emoji': '🛏️', 'category': 'House'},
    {'en': 'Bathroom', 'id': 'Kamar Mandi', 'emoji': '🛁', 'category': 'House'},
    {'en': 'Living Room', 'id': 'Ruang Tamu', 'emoji': '🛋️', 'category': 'House'},
    {'en': 'Garden', 'id': 'Taman', 'emoji': '🏡', 'category': 'House'},
    {'en': 'Teacher', 'id': 'Guru', 'emoji': '👩‍🏫', 'category': 'People'},
    {'en': 'Doctor', 'id': 'Dokter', 'emoji': '👨‍⚕️', 'category': 'People'},
    {'en': 'Pilot', 'id': 'Pilot', 'emoji': '👨‍✈️', 'category': 'People'},
    {'en': 'Chef', 'id': 'Koki', 'emoji': '👨‍🍳', 'category': 'People'},
    {'en': 'Farmer', 'id': 'Petani', 'emoji': '👨‍🌾', 'category': 'People'},
  ];

  /// Authentic Long Story Passages & Fables for Elementary Reading Comprehension (SD)
  static final List<Map<String, dynamic>> _readingStoriesPool = [
    {
      'title': 'The Ant and the Grasshopper',
      'emoji': '🐜',
      'colorHex': '#F59E0B',
      'category': 'fable',
      'text':
          'On a warm sunny summer day, a Grasshopper was hopping and singing merrily in the field. He saw a little Ant carrying heavy grains of wheat to her nest. "Why are you working so hard on this lovely day?" asked the Grasshopper. The Ant smiled and replied, "I am collecting food for the cold winter, and I suggest you do the same." The Grasshopper just laughed and continued to play. When winter came with heavy snow, the Grasshopper had no food to eat and was very hungry. But the Ant was warm and happy with plenty of food in her home.',
      'questions': [
        {
          'q': 'What was the little Ant doing during the sunny summer?',
          'a': 'Collecting food for the cold winter',
          'd': ['Playing and singing all day', 'Sleeping under a big rock', 'Swimming in the river'],
          'exp': 'Berdasarkan teks cerita, semut sibuk mengumpulkan makanan untuk persediaan musim dingin (collecting food for winter).',
        },
        {
          'q': 'What happened to the Grasshopper when the cold winter came?',
          'a': 'He had no food and was very hungry',
          'd': ['He built a warm stone house', 'He had many bags of wheat', 'He flew away to the forest'],
          'exp': 'Belalang kelaparan saat musim dingin karena tidak menyiapkan makanan selama musim panas.',
        },
        {
          'q': 'What is the moral lesson of the story?',
          'a': 'Hard work and preparation bring security',
          'd': ['Laziness is better than hard work', 'Singing is more important than eating', 'Winter is the best season for playing'],
          'exp': 'Pesan moral cerita adalah kerja keras dan persiapan akan membawa keselamatan dan kenyamanan.',
        },
        {
          'q': 'Where did the little Ant carry the grains of wheat?',
          'a': 'To her nest',
          'd': ['To the school bag', 'To the river bank', 'To the tree top'],
          'exp': 'Di dalam teks disebutkan: "carrying heavy grains of wheat to her nest".',
        },
      ],
    },
    {
      'title': 'The Tortoise and the Proud Hare',
      'emoji': '🐢',
      'colorHex': '#10B981',
      'category': 'fable',
      'text':
          'Once upon a time, a fast Hare was always boasting about how quickly he could run. The patient Tortoise grew tired of listening to him and challenged the Hare to a race. All the woodland animals gathered by the big oak tree to watch. When the race started, the Hare ran ahead like lightning. Seeing that the Tortoise was far behind, the confident Hare decided to take a short nap under a shady apple tree. Meanwhile, the slow Tortoise kept walking step by step without stopping. When the Hare finally woke up, the Tortoise had already crossed the finish line and won the race!',
      'questions': [
        {
          'q': 'Why did the fast Hare stop and fall asleep during the race?',
          'a': 'He was overconfident and took a nap',
          'd': ['His leg was badly hurt', 'It started to rain heavily', 'The Tortoise told him to sleep'],
          'exp': 'Kelinci terlalu percaya diri sehingga memutuskan untuk tidur siang sejenak di bawah pohon.',
        },
        {
          'q': 'How did the patient Tortoise win the race against the Hare?',
          'a': 'By walking steadily without stopping',
          'd': ['By riding a fast bicycle', 'By taking a secret shortcut', 'By running faster than the Hare'],
          'exp': 'Kura-kura menang karena terus berjalan tanpa berhenti dengan sabar dan tekun.',
        },
        {
          'q': 'Where did the woodland animals gather to watch the race?',
          'a': 'By the big oak tree',
          'd': ['At the beach', 'Inside a deep cave', 'At the school yard'],
          'exp': 'Berdasarkan teks: "All the woodland animals gathered by the big oak tree to watch."',
        },
        {
          'q': 'What does the proverb "Slow and steady wins the race" teach us?',
          'a': 'Consistency and patience lead to success',
          'd': ['Speed is the only thing that matters', 'Taking a nap during work is always good', 'Never try new challenges'],
          'exp': 'Pepatah tersebut mengajarkan ketekunan dan kesabaran akan membawa kesuksesan.',
        },
      ],
    },
    {
      'title': 'The Clever Crow and the Pitcher',
      'emoji': '🐦',
      'colorHex': '#6366F1',
      'category': 'fable',
      'text':
          'On a scorching hot afternoon, a thirsty Crow flew all across the countryside searching for water. Finally, he spotted a tall glass pitcher standing on a garden table. The Crow eagerly flew down, but the water level was very low near the bottom. His beak was too short to reach the cool water. The Crow did not give up. He looked around the garden and noticed a pile of small smooth pebbles. One by one, the Crow picked up the pebbles with his beak and dropped them into the pitcher. With every pebble, the water level rose higher. At last, the water reached the rim, and the clever Crow drank happily.',
      'questions': [
        {
          'q': 'Why could the thirsty Crow not reach the water at first?',
          'a': 'The water level was too low at the bottom',
          'd': ['The pitcher was tightly closed', 'The water was too hot to drink', 'Another bird guarded the pitcher'],
          'exp': 'Gagak tidak bisa minum pada awalnya karena air berada terlalu rendah di dasar kendi.',
        },
        {
          'q': 'What clever idea did the Crow use to solve his problem?',
          'a': 'Dropping pebbles into the pitcher to raise the water',
          'd': ['Knocking over the heavy pitcher', 'Waiting for rainfall in the garden', 'Breaking the glass with a stone'],
          'exp': 'Gagak menjatuhkan kerikil satu per satu agar permukaan air naik ke atas kendi.',
        },
        {
          'q': 'Where was the tall glass pitcher located?',
          'a': 'On a garden table',
          'd': ['Inside a kitchen cupboard', 'Under the river bridge', 'On a classroom desk'],
          'exp': 'Berdasarkan cerita: "he spotted a tall glass pitcher standing on a garden table."',
        },
        {
          'q': 'What quality best describes the Crow in this fable?',
          'a': 'Clever and persevering',
          'd': ['Lazy and impatient', 'Angry and jealous', 'Cowardly and shy'],
          'exp': 'Sifat burung gagak dalam fabel ini adalah cerdik (clever) dan pantang menyerah (persevering).',
        },
      ],
    },
    {
      'title': 'The Lion and the Little Mouse',
      'emoji': '🦁',
      'colorHex': '#EF4444',
      'category': 'fable',
      'text':
          'A great Lion was sleeping peacefully under the golden savannah sun when a tiny Mouse accidentally ran across his big paws. The Lion awoke with a loud roar and trapped the little Mouse under his mighty claws. "Please spare my life, King of the Jungle!" begged the trembling Mouse. "Someday, I might help you in return." The Lion laughed at the silly idea of a mouse helping a lion, but he kindly let her go. A few weeks later, the Lion was caught in a hunter\'s strong rope net. He roared loudly in distress. Hearing his cries, the little Mouse hurried over and used her sharp front teeth to gnaw through the thick ropes until the Lion was free.',
      'questions': [
        {
          'q': 'How did the tiny Mouse help the mighty Lion escape?',
          'a': 'She gnawed through the thick ropes with her sharp teeth',
          'd': ['She unlocked the cage with a silver key', 'She fought the hunters with a stick', 'She called an elephant to pull the net'],
          'exp': 'Tikus menggigit tali jaring yang tebal dengan gigi tajamnya sampai singa terbebas.',
        },
        {
          'q': 'Why did the Lion laugh when the Mouse begged for her life?',
          'a': 'He thought a tiny mouse could never help a huge lion',
          'd': ['The Mouse told a hilarious joke', 'He was playing a funny game', 'He saw a monkey dancing nearby'],
          'exp': 'Singa tertawa geli karena mengira hewan sekecil tikus tidak akan pernah bisa menolong raja rimba.',
        },
        {
          'q': 'What kind of trap held the Lion captive?',
          'a': 'A hunter\'s strong rope net',
          'd': ['A deep wooden pit', 'An iron metal cage', 'A muddy quicksand pool'],
          'exp': 'Disebutkan dalam teks: "the Lion was caught in a hunter\'s strong rope net."',
        },
        {
          'q': 'What valuable lesson does this fable share with readers?',
          'a': 'Even small friends can be of great help',
          'd': ['Lions should never sleep outdoors', 'Mice are stronger than hunters', 'Ropes are easy to break'],
          'exp': 'Cerita ini mengajarkan bahwa bahkan teman yang kecil pun bisa memberikan pertolongan yang sangat berharga.',
        },
      ],
    },
    {
      'title': 'Pippin, the Clever Little Squirrel',
      'emoji': '🐿️',
      'colorHex': '#D97706',
      'category': 'fable',
      'text':
          'Deep inside the whispering pine forest lived Pippin, a lively squirrel with a bushy red tail and sharp twinkling eyes. While other squirrels played tag all day, Pippin spent his autumn mornings searching for the finest brown acorns and hazelnuts. Whenever he found a ripe nut, he buried it secretly under soft moss near distinctive pine trees and marked the spots in his memory. When autumn ended and icy winter snow blanketed the forest ground, the other animals were anxious about food. Pippin cheerfully shared his hidden acorn treasures with his forest neighbors so no one went hungry.',
      'questions': [
        {
          'q': 'What nuts did Pippin collect during autumn mornings?',
          'a': 'Brown acorns and hazelnuts',
          'd': ['Peanuts and walnuts', 'Cashews and almonds', 'Corn and sunflower seeds'],
          'exp': 'Pippin mengumpulkan biji ek cokelat dan hazelnut (brown acorns and hazelnuts).',
        },
        {
          'q': 'Where did Pippin hide his collected nuts?',
          'a': 'Under soft moss near distinctive pine trees',
          'd': ['Inside an old fisherman boot', 'At the bottom of the deep river', 'Inside a human kitchen'],
          'exp': 'Berdasarkan cerita: "buried it secretly under soft moss near distinctive pine trees".',
        },
        {
          'q': 'What kind action did Pippin do when winter snow covered the forest?',
          'a': 'He cheerfully shared his hidden acorn treasures with neighbors',
          'd': ['He hid alone in his tree hollow', 'He moved away to the tropical beach', 'He sold the acorns for golden coins'],
          'exp': 'Pippin dengan baik hati membagikan simpanan biji eknya kepada tetangga hutan.',
        },
        {
          'q': 'What feature describes Pippin\'s appearance?',
          'a': 'A bushy red tail and sharp twinkling eyes',
          'd': ['A bald head and long whiskers', 'Green wings and yellow feathers', 'A short spotted tail'],
          'exp': 'Teks mendeskripsikan: "a lively squirrel with a bushy red tail and sharp twinkling eyes".',
        },
      ],
    },
    {
      'title': 'My Fluffy White Cat, Milo',
      'emoji': '🐱',
      'colorHex': '#8B5CF6',
      'category': 'descriptive',
      'text':
          'Milo is my beloved pet cat. He is two years old with thick, snow-white fur that feels like soft cotton. Milo has sparkling blue eyes and curious pink ears that twitch whenever he hears a bird chirping outside the window. Every morning, Milo rubs gently against my legs and purrs softly to ask for warm milk and tuna biscuits. In the sunny afternoon, his favorite hobby is chasing yellow butterflies around the front garden flowers. When the stars appear at night, Milo curls up into a round furry ball on the edge of my bed and falls asleep peacefully.',
      'questions': [
        {
          'q': 'What color is Milo\'s fur and what color are his sparkling eyes?',
          'a': 'Snow-white fur and sparkling blue eyes',
          'd': ['Golden fur and green eyes', 'Spotted black fur and brown eyes', 'Gray fur and yellow eyes'],
          'exp': 'Teks menyebutkan: "snow-white fur that feels like soft cotton" dan "sparkling blue eyes".',
        },
        {
          'q': 'What does Milo love to do in the front garden on sunny afternoons?',
          'a': 'Chasing yellow butterflies around the flowers',
          'd': ['Climbing tall coconut trees', 'Digging big holes in the grass', 'Swimming in the pond'],
          'exp': 'Kegiatan favorit Milo di sore hari adalah mengejar kupu-kupu kuning (chasing yellow butterflies).',
        },
        {
          'q': 'What food and drink does Milo ask for in the morning?',
          'a': 'Warm milk and tuna biscuits',
          'd': ['Orange juice and pancakes', 'Fresh apples and bread', 'Carrot soup and meatball'],
          'exp': 'Disebutkan dalam teks: "purrs softly to ask for warm milk and tuna biscuits".',
        },
        {
          'q': 'Where does Milo sleep when night comes?',
          'a': 'On the edge of the bed like a round furry ball',
          'd': ['Inside a wooden garage box', 'Under the kitchen sink', 'On the garden tree branch'],
          'exp': 'Milo tidur melingkar di ujung tempat tidur (curls up on the edge of my bed).',
        },
      ],
    },
    {
      'title': 'Our School Botanical Garden',
      'emoji': '🌻',
      'colorHex': '#EC4899',
      'category': 'descriptive',
      'text':
          'Behind our elementary school building, there is a vibrant botanical garden lovingly cared for by teachers and students. Bright sunflowers stand tall along the wooden fence, smiling towards the morning sun. In the center, sweet red roses and purple orchids blossom beside a clear bubbling fishpond full of orange koi fish. Every Tuesday afternoon, the student green club members gather with green watering cans to water the herbs and vegetables. There are two smooth wooden benches under a shady mango tree where pupils love to sit, read storybooks, and enjoy the refreshing breeze.',
      'questions': [
        {
          'q': 'What fish swim inside the clear bubbling pond in the garden?',
          'a': 'Orange koi fish',
          'd': ['Silver sharks', 'Blue whales', 'Green turtles'],
          'exp': 'Berdasarkan teks: "beside a clear bubbling fishpond full of orange koi fish".',
        },
        {
          'q': 'When do the student green club members water the garden plants?',
          'a': 'Every Tuesday afternoon',
          'd': ['Every Sunday morning', 'Every Friday evening', 'Only during rainy days'],
          'exp': 'Teks menuliskan: "Every Tuesday afternoon, the student green club members gather".',
        },
        {
          'q': 'What tall flowers grow along the wooden fence of the botanical garden?',
          'a': 'Bright sunflowers',
          'd': ['White water lilies', 'Cactus plants', 'Tall pine cones'],
          'exp': 'Berdasarkan bacaan: "Bright sunflowers stand tall along the wooden fence".',
        },
        {
          'q': 'What do pupils enjoy doing on the wooden benches under the mango tree?',
          'a': 'Reading storybooks and enjoying the fresh breeze',
          'd': ['Playing computer video games', 'Cooking instant noodles', 'Washing school uniforms'],
          'exp': 'Murid-murid suka duduk membaca buku cerita dan menikmati angin sejuk di bawah pohon mangga.',
        },
      ],
    },
    {
      'title': 'Syalumi and Sinan\'s Cozy Treehouse',
      'emoji': '🏡',
      'colorHex': '#06B6D4',
      'category': 'descriptive',
      'text':
          'Syalumi and Sinan built an amazing treehouse with their father on a sturdy banyan tree in the backyard. To climb inside, they use a wooden ladder with thick hemp ropes. Inside the cozy wooden room, there is a soft green carpet, fairy string lights hung across the ceiling, and shelves packed with adventure novels and colorful drawing paper. Through the round window, they have a breathtaking view of the green hill and village river. On weekend afternoons, their mother brings up homemade cookies and cold lemon tea for them to enjoy while doing homework.',
      'questions': [
        {
          'q': 'On what kind of tree is the treehouse built?',
          'a': 'A sturdy banyan tree in the backyard',
          'd': ['A tall coconut palm by the beach', 'A small rose bush', 'An apple tree in the school yard'],
          'exp': 'Berdasarkan teks: "built an amazing treehouse with their father on a sturdy banyan tree in the backyard".',
        },
        {
          'q': 'How do Syalumi and Sinan climb into their treehouse?',
          'a': 'Using a wooden ladder with thick hemp ropes',
          'd': ['By flying in a toy hot-air balloon', 'Using an electric glass elevator', 'Climbing a metal water pipe'],
          'exp': 'Mereka memanjat menggunakan tangga kayu bertali rami (a wooden ladder with thick hemp ropes).',
        },
        {
          'q': 'What treats does mother bring up to the treehouse on weekends?',
          'a': 'Homemade cookies and cold lemon tea',
          'd': ['Hot coffee and pizza', 'Fried chicken and soda', 'Chocolates and ice cream soup'],
          'exp': 'Disebutkan: "their mother brings up homemade cookies and cold lemon tea".',
        },
        {
          'q': 'What scenic view can be seen through the treehouse round window?',
          'a': 'The green hill and village river',
          'd': ['A busy airport runway', 'A crowded supermarket parking lot', 'The open ocean waves'],
          'exp': 'Pemandangan dari jendela bulat adalah bukit hijau dan sungai desa (the green hill and village river).',
        },
      ],
    },
    {
      'title': 'A Thrilling Day at the Safari Zoo',
      'emoji': '🦒',
      'colorHex': '#14B8A6',
      'category': 'descriptive',
      'text':
          'Last Saturday, Grade 1 students went on an exciting field trip to Safari Adventure Park. They rode in a big yellow tour bus with wide open windows. First, they passed the grassy savannah where graceful giraffes stretched their long necks to nibble acacia leaves from tall trees. Next, two giant grey elephants sprayed cool water with their long trunks to take a refreshing bath in the river. The tour guide gave each student a bunch of crunchy carrots to safely feed the gentle zebras. Everyone cheered with delight and took wonderful photographs for their school scrapbooks.',
      'questions': [
        {
          'q': 'What vehicle did the students ride during their safari park tour?',
          'a': 'A big yellow tour bus',
          'd': ['A red speed boat', 'A blue steam train', 'Individual bicycles'],
          'exp': 'Siswa menaiki bus tur kuning besar (a big yellow tour bus).',
        },
        {
          'q': 'How did the giant grey elephants take a refreshing bath?',
          'a': 'By spraying cool water with their long trunks',
          'd': ['By diving deep under a waterfall', 'By sitting in a ceramic bathtub', 'By using a garden hose'],
          'exp': 'Gajah menyemprotkan air sejuk dengan belalainya yang panjang untuk mandi.',
        },
        {
          'q': 'What vegetable did students feed to the gentle zebras?',
          'a': 'Crunchy carrots',
          'd': ['Sweet potatoes', 'Red tomatoes', 'Green cucumbers'],
          'exp': 'Siswa memberi makan wortel renyah (crunchy carrots) kepada zebra.',
        },
        {
          'q': 'What did the graceful giraffes eat from the tall trees?',
          'a': 'Acacia leaves',
          'd': ['Ripe papayas', 'Coconuts', 'Pineapples'],
          'exp': 'Jerapah memakan daun akasia (nibble acacia leaves from tall trees).',
        },
      ],
    },
    {
      'title': 'Flash, the Courageous Fire Truck',
      'emoji': '🚒',
      'colorHex': '#DC2626',
      'category': 'descriptive',
      'text':
          'Flash is a shiny red fire truck stationed at the Central Town Firehouse. He is equipped with a very long silver ladder, flashing blue emergency lights, and a powerful siren that goes "Wee-Woo-Wee-Woo" when called into action. Inside his tanks, Flash carries thousands of liters of clean water and extra-long canvas hoses. Firefighter Captain John and his brave team always wash Flash every sunrise until his chrome wheels sparkle. When an emergency call rings, Flash speeds safely down the road, ready to put out fires and rescue cute kittens trapped in high trees.',
      'questions': [
        {
          'q': 'What sound does Flash\'s powerful emergency siren make?',
          'a': '"Wee-Woo-Wee-Woo"',
          'd': ['"Beep-Beep-Beep"', '"Honk-Honk-Honk"', '"Ding-Dong-Ding"'],
          'exp': 'Berdasarkan teks: "a powerful siren that goes \'Wee-Woo-Wee-Woo\'".',
        },
        {
          'q': 'Who is the captain that leads the firefighting team?',
          'a': 'Firefighter Captain John',
          'd': ['Captain Hook', 'Captain Robert', 'Officer David'],
          'exp': 'Kapten pemadam kebakaran bernama Captain John.',
        },
        {
          'q': 'What rescues does Flash help perform besides putting out fires?',
          'a': 'Rescuing cute kittens trapped in high trees',
          'd': ['Fixing broken bicycles on the road', 'Delivering birthday parcels to houses', 'Painting school walls'],
          'exp': 'Flash membantu menyelamatkan anak kucing yang terjebak di pohon tinggi.',
        },
        {
          'q': 'What color is Flash and what kind of ladder does he carry?',
          'a': 'Shiny red with a very long silver ladder',
          'd': ['Bright yellow with a short rope ladder', 'Deep black with a wooden ladder', 'Dark green with a metal pole'],
          'exp': 'Flash berwarna merah mengkilap dengan tangga perak yang sangat panjang.',
        },
      ],
    },
  ];

  static List<Map<String, dynamic>> _getReadingQuestions({String filterCategory = ''}) {
    final List<Map<String, dynamic>> list = [];
    for (var story in _readingStoriesPool) {
      if (filterCategory.isNotEmpty && story['category'] != filterCategory) {
        continue;
      }
      final questions = story['questions'] as List<Map<String, dynamic>>;
      for (var q in questions) {
        list.add({
          'storyTitle': story['title'],
          'emoji': story['emoji'],
          'colorHex': story['colorHex'],
          'storyText': story['text'],
          'q': q['q'],
          'a': q['a'],
          'd': q['d'],
          'exp': q['exp'],
        });
      }
    }
    return list;
  }

  /// Procedural & Topic-Specific Dynamic English Question Generator for SD
  /// Generates 100% UNIQUE, non-repetitive English questions per topic up to 100+ variations!
  static List<Question> generateDynamicEnglishQuestions({
    required String gradeLevel,
    required int classNum,
    required int count,
    String topic = 'General English',
  }) {
    final List<Question> questions = [];
    final Set<String> seenQuestionTexts = {};
    final random = Random();
    int attempts = 0;

    final tLower = topic.toLowerCase().trim();
    final bool isReadingTopic = tLower.contains('reading') ||
        tLower.contains('descriptive') ||
        tLower.contains('story') ||
        tLower.contains('stories') ||
        tLower.contains('fable') ||
        tLower.contains('passage') ||
        tLower.contains('comprehension') ||
        tLower.contains('cerita') ||
        tLower.contains('dongeng') ||
        tLower.contains('bacaan');

    while (questions.length < count && attempts < 1500) {
      attempts++;
      final versionType = random.nextInt(10);

      late String qText;
      late List<String> options;
      late int correctIndex;
      late String explanationText;
      late String levelTag;

      String visualType = 'english_vocab_card';
      Map<String, dynamic> visualData = {};
      String visualLabel = 'Petunjuk Visual';

      final studentName = _studentNames[random.nextInt(_studentNames.length)];

      // -----------------------------------------------------------------------
      // 0. READING COMPREHENSION & LONG STORY PASSAGES (Soal Cerita Panjang SD)
      // -----------------------------------------------------------------------
      if (isReadingTopic) {
        levelTag = 'Sedang';
        visualType = 'english_reading_passage';

        List<Map<String, dynamic>> candidates = [];
        if (tLower.contains('descriptive')) {
          candidates = _getReadingQuestions(filterCategory: 'descriptive');
          if (candidates.length < count) {
            candidates.addAll(_getReadingQuestions(filterCategory: 'fable'));
          }
        } else if (tLower.contains('fable') ||
            tLower.contains('story') ||
            tLower.contains('stories') ||
            tLower.contains('dongeng')) {
          candidates = _getReadingQuestions(filterCategory: 'fable');
          if (candidates.length < count) {
            candidates.addAll(_getReadingQuestions(filterCategory: 'descriptive'));
          }
        } else {
          candidates = _getReadingQuestions();
        }

        final rq = candidates[random.nextInt(candidates.length)];
        qText = rq['q'] as String;
        final opts = [rq['a'] as String, ...(rq['d'] as List<String>)]..shuffle();
        options = opts;
        correctIndex = opts.indexOf(rq['a'] as String);
        explanationText = rq['exp'] as String;
        visualData = {
          'storyTitle': rq['storyTitle'],
          'storyText': rq['storyText'],
          'emoji': rq['emoji'],
          'colorHex': rq['colorHex'],
        };
        visualLabel = 'Teks Bacaan Cerita';
      }

      // -----------------------------------------------------------------------
      // 1. ALPHABET & PHONICS
      // -----------------------------------------------------------------------
      else if (tLower.contains('phonics') || tLower.contains('alphabet')) {
        levelTag = 'Dasar';
        final phonicsPool = [
          {'sound': '/b/', 'correct': 'Ball', 'emoji': '⚽', 'd': ['Cat', 'Dog', 'Apple']},
          {'sound': '/c/', 'correct': 'Cat', 'emoji': '🐱', 'd': ['Dog', 'Ball', 'Elephant']},
          {'sound': '/d/', 'correct': 'Dog', 'emoji': '🐶', 'd': ['Cat', 'Banana', 'Fish']},
          {'sound': '/f/', 'correct': 'Fish', 'emoji': '🐟', 'd': ['Apple', 'Dog', 'Cat']},
          {'sound': '/m/', 'correct': 'Moon', 'emoji': '🌙', 'd': ['Sun', 'Star', 'Tree']},
          {'sound': '/p/', 'correct': 'Pencil', 'emoji': '✏️', 'd': ['Book', 'Ruler', 'Desk']},
          {'sound': '/s/', 'correct': 'Sun', 'emoji': '☀️', 'd': ['Moon', 'Cloud', 'Rain']},
          {'sound': '/t/', 'correct': 'Tiger', 'emoji': '🐯', 'd': ['Lion', 'Monkey', 'Bear']},
          {'sound': '/a/', 'correct': 'Apple', 'emoji': '🍎', 'd': ['Orange', 'Banana', 'Grape']},
          {'sound': '/r/', 'correct': 'Rabbit', 'emoji': '🐰', 'd': ['Duck', 'Bird', 'Frog']},
          {'sound': '/g/', 'correct': 'Giraffe', 'emoji': '🦒', 'd': ['Zebra', 'Hippo', 'Horse']},
          {'sound': '/h/', 'correct': 'House', 'emoji': '🏠', 'd': ['Car', 'Tree', 'Book']},
          {'sound': '/l/', 'correct': 'Lion', 'emoji': '🦁', 'd': ['Tiger', 'Bear', 'Dog']},
          {'sound': '/w/', 'correct': 'Watermelon', 'emoji': '🍉', 'd': ['Apple', 'Grape', 'Orange']},
        ];

        if (versionType == 0) {
          final pItem = phonicsPool[random.nextInt(phonicsPool.length)];
          qText = 'Which English word starts with the phonic sound ${pItem['sound']}?';
          final opts = [pItem['correct'] as String, ...pItem['d'] as List<String>]..shuffle();
          options = opts;
          correctIndex = opts.indexOf(pItem['correct'] as String);
          explanationText = 'Kata "${pItem['correct']}" diawali dengan bunyi fonik ${pItem['sound']}.';
          visualData = {'emoji': pItem['emoji'], 'title': 'Alphabet & Phonics', 'subtitle': 'Bunyi Fonik ${pItem['sound']}', 'colorHex': '#4CC9F0'};
        } else if (versionType == 1) {
          final spellWords = [
            {'word': 'B-O-O-K', 'ans': 'Book', 'emoji': '📚'},
            {'word': 'A-P-P-L-E', 'ans': 'Apple', 'emoji': '🍎'},
            {'word': 'P-E-N-C-I-L', 'ans': 'Pencil', 'emoji': '✏️'},
            {'word': 'C-A-T', 'ans': 'Cat', 'emoji': '🐱'},
            {'word': 'D-O-G', 'ans': 'Dog', 'emoji': '🐶'},
            {'word': 'F-I-S-H', 'ans': 'Fish', 'emoji': '🐟'},
          ];
          final sp = spellWords[random.nextInt(spellWords.length)];
          qText = 'How do you spell "${sp['ans']}" in English?';
          final opts = [sp['word'] as String, sp['word']!.replaceAll('-', ''), 'B-A-G-S', 'S-C-H-O-O-L']..shuffle();
          options = opts;
          correctIndex = opts.indexOf(sp['word'] as String);
          explanationText = 'Ejaan yang tepat untuk "${sp['ans']}" adalah ${sp['word']}.';
          visualData = {'emoji': sp['emoji'], 'title': 'Spelling Test', 'subtitle': 'Petunjuk Ejaan', 'colorHex': '#4361EE'};
        } else if (versionType == 2) {
          qText = 'Which group contains ONLY English Vowels (Huruf Vokal)?';
          options = ['A, E, I, O, U', 'B, C, D, F, G', 'A, B, C, D, E', 'X, Y, Z, W, V']..shuffle();
          correctIndex = options.indexOf('A, E, I, O, U');
          explanationText = 'Huruf vokal dalam abjad bahasa Inggris terdiri dari 5 huruf: A, E, I, O, U.';
          visualData = {'emoji': '🔤', 'title': 'Vowel Letters', 'subtitle': 'Huruf Vokal', 'colorHex': '#3F51B5'};
        } else if (versionType == 3) {
          final vItem = _vocabPool[random.nextInt(_vocabPool.length)];
          qText = 'What is the English word for "${vItem['id']}"?';
          final opts = [vItem['en']!];
          int optTries = 0;
          while (opts.length < 4 && optTries < 40) {
            optTries++;
            final randItem = _vocabPool[random.nextInt(_vocabPool.length)];
            if (!opts.contains(randItem['en'])) opts.add(randItem['en']!);
          }
          opts.shuffle();
          options = opts;
          correctIndex = opts.indexOf(vItem['en']!);
          explanationText = 'Bahasa Inggris dari "${vItem['id']}" adalah "${vItem['en']}".';
          visualData = {'emoji': vItem['emoji'], 'title': 'Basic Vocabulary', 'subtitle': 'Gambar Petunjuk', 'colorHex': '#9C27B0'};
        } else if (versionType == 4) {
          final letters = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];
          final idx = random.nextInt(letters.length - 2) + 1;
          final prevL = letters[idx - 1];
          final nextL = letters[idx + 1];
          final ansL = letters[idx];
          qText = 'Which letter comes between "$prevL" and "$nextL" in the alphabet?';
          options = [ansL, letters[idx + 2], letters[idx - 2 < 0 ? 0 : idx - 2], 'Z']..shuffle();
          correctIndex = options.indexOf(ansL);
          explanationText = 'Urutan abjad: $prevL, $ansL, $nextL.';
          visualData = {'emoji': '🔤', 'title': 'Alphabet Order', 'subtitle': 'Urutan Abjad', 'colorHex': '#009688'};
        } else if (versionType == 5) {
          final missingWords = [
            {'missing': 'A - P - _ - L - E', 'ans': 'P', 'word': 'Apple', 'emoji': '🍎'},
            {'missing': 'B - _ - O - K', 'ans': 'O', 'word': 'Book', 'emoji': '📚'},
            {'missing': 'C - A - _', 'ans': 'T', 'word': 'Cat', 'emoji': '🐱'},
            {'missing': 'S - C - H - _ - O - L', 'ans': 'O', 'word': 'School', 'emoji': '🏫'},
          ];
          final mw = missingWords[random.nextInt(missingWords.length)];
          qText = 'Complete the missing letter: "${mw['missing']}"';
          options = [mw['ans'] as String, 'X', 'Z', 'M']..shuffle();
          correctIndex = options.indexOf(mw['ans'] as String);
          explanationText = 'Huruf yang hilang adalah ${mw['ans']} untuk membentuk kata "${mw['word']}".';
          visualData = {'emoji': mw['emoji'], 'title': 'Missing Letter', 'subtitle': 'Melengkapi Huruf', 'colorHex': '#FF9800'};
        } else {
          final firstLetterWord = [
            {'word': 'Elephant', 'letter': 'E', 'emoji': '🐘'},
            {'word': 'Monkey', 'letter': 'M', 'emoji': '🐒'},
            {'word': 'Zebra', 'letter': 'Z', 'emoji': '🦓'},
            {'word': 'Kangaroo', 'letter': 'K', 'emoji': '🦘'},
          ];
          final fl = firstLetterWord[random.nextInt(firstLetterWord.length)];
          qText = 'What is the first letter of the word "${fl['word']}"?';
          options = [fl['letter'] as String, 'A', 'B', 'P']..shuffle();
          correctIndex = options.indexOf(fl['letter'] as String);
          explanationText = 'Huruf pertama dari kata "${fl['word']}" adalah ${fl['letter']}.';
          visualData = {'emoji': fl['emoji'], 'title': 'First Letter', 'subtitle': 'Huruf Pertama', 'colorHex': '#E91E63'};
        }
        visualLabel = 'Petunjuk Fonik & Abjad';
      }

      // -----------------------------------------------------------------------
      // 2. NUMBERS, COLORS & SHAPES
      // -----------------------------------------------------------------------
      else if (tLower.contains('numbers') || tLower.contains('colors') || tLower.contains('shapes')) {
        levelTag = 'Dasar';
        if (versionType <= 2) {
          final numPool = [
            {'num': '15', 'correct': 'Fifteen', 'emoji': '1️⃣5️⃣', 'd': ['Fifty', 'Five', 'Fourteen']},
            {'num': '12', 'correct': 'Twelve', 'emoji': '1️⃣2️⃣', 'd': ['Twenty', 'Two', 'Ten']},
            {'num': '20', 'correct': 'Twenty', 'emoji': '2️⃣0️⃣', 'd': ['Twelve', 'Two', 'Thirteen']},
            {'num': '8', 'correct': 'Eight', 'emoji': '8️⃣', 'd': ['Eighty', 'Eighteen', 'Seven']},
            {'num': '11', 'correct': 'Eleven', 'emoji': '1️⃣1️⃣', 'd': ['Seven', 'One', 'Twelve']},
            {'num': '14', 'correct': 'Fourteen', 'emoji': '1️⃣4️⃣', 'd': ['Forty', 'Four', 'Fifteen']},
            {'num': '9', 'correct': 'Nine', 'emoji': '9️⃣', 'd': ['Ninety', 'Nineteen', 'Night']},
            {'num': '30', 'correct': 'Thirty', 'emoji': '3️⃣0️⃣', 'd': ['Thirteen', 'Three', 'Third']},
            {'num': '50', 'correct': 'Fifty', 'emoji': '5️⃣0️⃣', 'd': ['Fifteen', 'Five', 'Fifth']},
            {'num': '100', 'correct': 'One Hundred', 'emoji': '💯', 'd': ['Ten', 'One Thousand', 'Hundred']},
          ];
          final nItem = numPool[random.nextInt(numPool.length)];
          qText = 'What is the number "${nItem['num']}" in English words?';
          final opts = [nItem['correct'] as String, ...nItem['d'] as List<String>]..shuffle();
          options = opts;
          correctIndex = opts.indexOf(nItem['correct'] as String);
          explanationText = 'Angka ${nItem['num']} dalam bahasa Inggris adalah "${nItem['correct']}".';
          visualData = {'emoji': nItem['emoji'], 'title': 'Numbers & Words', 'subtitle': 'Angka ${nItem['num']}', 'colorHex': '#4361EE'};
        } else if (versionType <= 5) {
          final colorQuiz = [
            {'q': 'What color is the sky on a bright sunny day?', 'a': 'Blue', 'emoji': '🟦', 'd': ['Red', 'Green', 'Black']},
            {'q': 'What color is a ripe banana?', 'a': 'Yellow', 'emoji': '🟨', 'd': ['Purple', 'Blue', 'White']},
            {'q': 'What color is grass in the garden?', 'a': 'Green', 'emoji': '🟩', 'd': ['Yellow', 'Pink', 'Brown']},
            {'q': 'What color is a strawberry fruit?', 'a': 'Red', 'emoji': '🟥', 'd': ['Blue', 'Green', 'Black']},
            {'q': 'What is the English word for color "Ungu"?', 'a': 'Purple', 'emoji': '🟪', 'd': ['Orange', 'Pink', 'White']},
            {'q': 'What is the English word for color "Cokelat"?', 'a': 'Brown', 'emoji': '🤎', 'd': ['Black', 'Gray', 'Yellow']},
          ];
          final cq = colorQuiz[random.nextInt(colorQuiz.length)];
          qText = cq['q'] as String;
          final opts = [cq['a'] as String, ...cq['d'] as List<String>]..shuffle();
          options = opts;
          correctIndex = opts.indexOf(cq['a'] as String);
          explanationText = 'Warna yang tepat adalah "${cq['a']}".';
          visualData = {'emoji': cq['emoji'], 'title': 'Colors & Paints', 'subtitle': 'Petunjuk Warna', 'colorHex': '#E91E63'};
        } else {
          final shapePool = [
            {'q': 'What shape has three sides and three corners?', 'a': 'Triangle', 'emoji': '🔺', 'd': ['Square', 'Circle', 'Rectangle']},
            {'q': 'What shape is round like a football?', 'a': 'Circle', 'emoji': '🔴', 'd': ['Square', 'Triangle', 'Cube']},
            {'q': 'What shape has four equal sides?', 'a': 'Square', 'emoji': '🟦', 'd': ['Circle', 'Triangle', 'Oval']},
            {'q': 'What shape looks like an egg?', 'a': 'Oval', 'emoji': '🥚', 'd': ['Rectangle', 'Square', 'Triangle']},
            {'q': 'What shape has four sides with opposite sides equal?', 'a': 'Rectangle', 'emoji': '📄', 'd': ['Circle', 'Triangle', 'Star']},
          ];
          final sItem = shapePool[random.nextInt(shapePool.length)];
          qText = sItem['q'] as String;
          final opts = [sItem['a'] as String, ...sItem['d'] as List<String>]..shuffle();
          options = opts;
          correctIndex = opts.indexOf(sItem['a'] as String);
          explanationText = 'Bentuk geometri yang tepat adalah "${sItem['a']}".';
          visualData = {'emoji': sItem['emoji'], 'title': 'Shapes & Geometries', 'subtitle': 'Bentuk Geometri', 'colorHex': '#3F51B5'};
        }
        visualLabel = 'Petunjuk Angka, Warna & Bentuk';
      }

      // -----------------------------------------------------------------------
      // 3. FAMILY & GREETINGS
      // -----------------------------------------------------------------------
      else if (tLower.contains('family') || tLower.contains('greetings')) {
        levelTag = 'Dasar';
        final famPool = [
          {'q': 'What is the English word for "Ibu"?', 'a': 'Mother', 'emoji': '👩', 'd': ['Father', 'Sister', 'Brother']},
          {'q': 'What is the English word for "Ayah"?', 'a': 'Father', 'emoji': '👨', 'd': ['Uncle', 'Grandfather', 'Brother']},
          {'q': 'What is the English word for "Kakek"?', 'a': 'Grandfather', 'emoji': '👴', 'd': ['Grandmother', 'Father', 'Uncle']},
          {'q': 'What is the English word for "Nenek"?', 'a': 'Grandmother', 'emoji': '👵', 'd': ['Mother', 'Aunt', 'Sister']},
          {'q': 'What is the English word for "Saudara Perempuan"?', 'a': 'Sister', 'emoji': '👧', 'd': ['Brother', 'Mother', 'Uncle']},
          {'q': 'What is the English word for "Saudara Laki-laki"?', 'a': 'Brother', 'emoji': '👦', 'd': ['Sister', 'Father', 'Aunt']},
          {'q': 'What do you say when you meet someone at 07:00 AM?', 'a': 'Good morning', 'emoji': '🌅', 'd': ['Good night', 'Good evening', 'Goodbye']},
          {'q': 'What do you say before going to sleep at night?', 'a': 'Good night', 'emoji': '🌙', 'd': ['Good morning', 'Good afternoon', 'Hello']},
          {'q': 'What do you say when meeting a new friend politely?', 'a': 'Nice to meet you', 'emoji': '🤝', 'd': ['Good night', 'See you next week', 'I am sorry']},
          {'q': 'How do you reply when someone says "Thank you"?', 'a': 'You are welcome', 'emoji': '💙', 'd': ['I am sorry', 'Goodbye', 'Good morning']},
        ];
        final fItem = famPool[random.nextInt(famPool.length)];
        qText = fItem['q'] as String;
        final opts = [fItem['a'] as String, ...fItem['d'] as List<String>]..shuffle();
        options = opts;
        correctIndex = opts.indexOf(fItem['a'] as String);
        explanationText = 'Jawaban yang tepat adalah "${fItem['a']}".';
        visualData = {'emoji': fItem['emoji'], 'title': 'Family & Greetings', 'subtitle': 'Gambar Petunjuk', 'colorHex': '#E91E63'};
        visualLabel = 'Petunjuk Anggota Keluarga & Salam';
      }

      // -----------------------------------------------------------------------
      // 4. ANIMALS, FRUITS & FOOD
      // -----------------------------------------------------------------------
      else if (tLower.contains('animals') || tLower.contains('fruits') || tLower.contains('food')) {
        levelTag = 'Sedang';
        final foodPool = [
          {'q': 'What is the English word for "Kucing"?', 'a': 'Cat', 'emoji': '🐱', 'd': ['Dog', 'Bird', 'Rabbit']},
          {'q': 'Which fruit is yellow and long?', 'a': 'Banana', 'emoji': '🍌', 'd': ['Apple', 'Grape', 'Watermelon']},
          {'q': 'What is the king of the jungle animal?', 'a': 'Lion', 'emoji': '🦁', 'd': ['Mouse', 'Cat', 'Rabbit']},
          {'q': 'Complete: "I love to eat fried rice for _____ in the morning."', 'a': 'breakfast', 'emoji': '🍳', 'd': ['dinner', 'lunch', 'bedtime']},
          {'q': 'What is the English word for "Gajah"?', 'a': 'Elephant', 'emoji': '🐘', 'd': ['Horse', 'Tiger', 'Monkey']},
          {'q': 'Which animal produces milk for humans to drink?', 'a': 'Cow', 'emoji': '🐄', 'd': ['Lion', 'Snake', 'Eagle']},
          {'q': 'What is the favorite food of a rabbit?', 'a': 'Carrot', 'emoji': '🥕', 'd': ['Meat', 'Fish', 'Cheese']},
          {'q': 'What do we call the meal we eat in the middle of the day?', 'a': 'Lunch', 'emoji': '🍱', 'd': ['Breakfast', 'Dinner', 'Supper']},
        ];
        final fdItem = foodPool[random.nextInt(foodPool.length)];
        qText = fdItem['q'] as String;
        final opts = [fdItem['a'] as String, ...fdItem['d'] as List<String>]..shuffle();
        options = opts;
        correctIndex = opts.indexOf(fdItem['a'] as String);
        explanationText = 'Jawaban yang benar adalah "${fdItem['a']}".';
        visualData = {'emoji': fdItem['emoji'], 'title': 'Animals, Fruits & Food', 'subtitle': 'Gambar Petunjuk', 'colorHex': '#4CAF50'};
        visualLabel = 'Petunjuk Hewan & Makanan';
      }

      // -----------------------------------------------------------------------
      // 5. CLASSROOM & SCHOOL OBJECTS
      // -----------------------------------------------------------------------
      else if (tLower.contains('classroom') || tLower.contains('school objects')) {
        levelTag = 'Dasar';
        final schoolPool = [
          {'q': 'What is the English word for "Pensil"?', 'a': 'Pencil', 'emoji': '✏️', 'd': ['Eraser', 'Ruler', 'Book']},
          {'q': 'What item do students use to erase pencil marks?', 'a': 'Eraser', 'emoji': '🧹', 'd': ['Pencil', 'Ruler', 'Whiteboard']},
          {'q': 'Which item belongs in a school bag?', 'a': 'Textbook', 'emoji': '🎒', 'd': ['Spoon', 'Pillow', 'Sofa']},
          {'q': 'Complete: "The teacher writes on the _____ with a marker."', 'a': 'whiteboard', 'emoji': '🖥️', 'd': ['floor', 'window', 'door']},
          {'q': 'What tool is used for measuring lines in centimeters?', 'a': 'Ruler', 'emoji': '📏', 'd': ['Clock', 'Bag', 'Chalk']},
          {'q': 'Where do students sit in the classroom?', 'a': 'Chair', 'emoji': '🪑', 'd': ['Door', 'Whiteboard', 'Ceiling']},
        ];
        final scItem = schoolPool[random.nextInt(schoolPool.length)];
        qText = scItem['q'] as String;
        final opts = [scItem['a'] as String, ...scItem['d'] as List<String>]..shuffle();
        options = opts;
        correctIndex = opts.indexOf(scItem['a'] as String);
        explanationText = 'Kosakata sekolah yang tepat adalah "${scItem['a']}".';
        visualData = {'emoji': scItem['emoji'], 'title': 'Classroom Objects', 'subtitle': 'Benda Sekolah', 'colorHex': '#FF9800'};
        visualLabel = 'Petunjuk Peralatan Sekolah';
      }

      // -----------------------------------------------------------------------
      // 6. HOUSE ROOMS & FURNITURE
      // -----------------------------------------------------------------------
      else if (tLower.contains('house') || tLower.contains('rooms') || tLower.contains('furniture')) {
        levelTag = 'Sedang';
        final housePool = [
          {'q': 'What is the English word for "Dapur"?', 'a': 'Kitchen', 'emoji': '🍳', 'd': ['Garage', 'Bedroom', 'Garden']},
          {'q': 'Which room in the house is used for sleeping?', 'a': 'Bedroom', 'emoji': '🛏️', 'd': ['Kitchen', 'Garage', 'Bathroom']},
          {'q': 'Where is the stove located in the house?', 'a': 'In the kitchen', 'emoji': '🔥', 'd': ['In the bedroom', 'In the garden', 'In the bathroom']},
          {'q': 'What is the English word for "Ruang Tamu"?', 'a': 'Living Room', 'emoji': '🛋️', 'd': ['Bedroom', 'Kitchen', 'Bathroom']},
          {'q': 'Where do people park their cars at home?', 'a': 'Garage', 'emoji': '🚗', 'd': ['Kitchen', 'Bedroom', 'Balcony']},
          {'q': 'Where do you wash your body or take a shower?', 'a': 'Bathroom', 'emoji': '🛁', 'd': ['Garage', 'Living Room', 'Kitchen']},
        ];
        final hItem = housePool[random.nextInt(housePool.length)];
        qText = hItem['q'] as String;
        final opts = [hItem['a'] as String, ...hItem['d'] as List<String>]..shuffle();
        options = opts;
        correctIndex = opts.indexOf(hItem['a'] as String);
        explanationText = 'Ruangan rumah yang tepat adalah "${hItem['a']}".';
        visualData = {'emoji': hItem['emoji'], 'title': 'House & Rooms', 'subtitle': 'Gambar Ruangan', 'colorHex': '#9C27B0'};
        visualLabel = 'Petunjuk Ruangan Rumah';
      }

      // -----------------------------------------------------------------------
      // 7. PRESENT TENSE & DAILY ROUTINES
      // -----------------------------------------------------------------------
      else if (tLower.contains('routines') || tLower.contains('daily') || (tLower.contains('present') && tLower.contains('tense') && !tLower.contains('perfect'))) {
        levelTag = 'Sedang';
        final routinePool = [
          {'q': 'Complete: "I _____ up at 06:00 AM every morning."', 'a': 'wake', 'emoji': '⏰', 'd': ['sleep', 'fly', 'swim']},
          {'q': 'What time is "07:00" in English?', 'a': 'Seven o\'clock', 'emoji': '🕒', 'd': ['Seven thirty', 'Six o\'clock', 'Eight o\'clock']},
          {'q': 'Complete: "She _____ to school by bicycle every day."', 'a': 'goes', 'emoji': '🚲', 'd': ['go', 'going', 'went']},
          {'q': 'Complete: "We _____ lunch in the school canteen at noon."', 'a': 'eat', 'emoji': '🍱', 'd': ['sleep', 'wash', 'write']},
          {'q': 'Complete: "$studentName _____ his teeth before sleeping."', 'a': 'brushes', 'emoji': '🪥', 'd': ['brush', 'brushing', 'brushed']},
          {'q': 'Complete: "They _____ football in the yard every afternoon."', 'a': 'play', 'emoji': '⚽', 'd': ['plays', 'playing', 'played']},
        ];
        final rItem = routinePool[random.nextInt(routinePool.length)];
        qText = rItem['q'] as String;
        final opts = [rItem['a'] as String, ...rItem['d'] as List<String>]..shuffle();
        options = opts;
        correctIndex = opts.indexOf(rItem['a'] as String);
        explanationText = 'Kata kerja rutinitas yang benar adalah "${rItem['a']}".';
        visualData = {'emoji': rItem['emoji'], 'title': 'Daily Routines', 'subtitle': 'Aktivitas Sehari-hari', 'colorHex': '#009688'};
        visualLabel = 'Petunjuk Aktivitas Harian';
      }

      // -----------------------------------------------------------------------
      // 8. HOBBIES & FREE TIME
      // -----------------------------------------------------------------------
      else if (tLower.contains('hobbies') || tLower.contains('free time')) {
        levelTag = 'Dasar';
        final hobbyPool = [
          {'q': 'What is the hobby of playing with a soccer ball?', 'a': 'Playing Football', 'emoji': '⚽', 'd': ['Swimming', 'Reading', 'Drawing']},
          {'q': 'Complete: "$studentName likes reading _____ in her free time."', 'a': 'books', 'emoji': '📚', 'd': ['tables', 'shoes', 'bicycles']},
          {'q': 'What hobby involves swimming in the pool?', 'a': 'Swimming', 'emoji': '🏊', 'd': ['Cooking', 'Singing', 'Dancing']},
          {'q': 'What hobby involves making delicious food in the kitchen?', 'a': 'Cooking', 'emoji': '🍳', 'd': ['Singing', 'Cycling', 'Running']},
          {'q': 'What hobby involves drawing and coloring pictures with pencils?', 'a': 'Drawing', 'emoji': '🎨', 'd': ['Reading', 'Swimming', 'Sleeping']},
        ];
        final hbItem = hobbyPool[random.nextInt(hobbyPool.length)];
        qText = hbItem['q'] as String;
        final opts = [hbItem['a'] as String, ...hbItem['d'] as List<String>]..shuffle();
        options = opts;
        correctIndex = opts.indexOf(hbItem['a'] as String);
        explanationText = 'Hobi yang tepat adalah "${hbItem['a']}".';
        visualData = {'emoji': hbItem['emoji'], 'title': 'Hobbies & Activity', 'subtitle': 'Gambar Hobi', 'colorHex': '#E91E63'};
        visualLabel = 'Petunjuk Hobi';
      }

      // -----------------------------------------------------------------------
      // 9. TO BE (IS / AM / ARE) & DO / DOES
      // -----------------------------------------------------------------------
      else if (tLower.contains('to be') || tLower.contains('do/does') || tLower.contains('grammar')) {
        levelTag = 'Sedang';
        final toBeQuiz = [
          {'q': 'Complete: "I _____ a diligent student at SD Merdeka."', 'a': 'am', 'emoji': '🎓', 'd': ['is', 'are', 'be']},
          {'q': 'Complete: "She _____ reading a comic book in the library."', 'a': 'is', 'emoji': '📖', 'd': ['am', 'are', 'be']},
          {'q': 'Complete: "They _____ playing football in the school yard."', 'a': 'are', 'emoji': '⚽', 'd': ['is', 'am', 'was']},
          {'q': 'Complete: "_____ he like playing badminton?"', 'a': 'Does', 'emoji': '🏸', 'd': ['Do', 'Is', 'Are']},
          {'q': 'Complete: "_____ you have a pencil?"', 'a': 'Do', 'emoji': '✏️', 'd': ['Does', 'Is', 'Am']},
          {'q': 'Complete: "We _____ happy to study English together."', 'a': 'are', 'emoji': '😊', 'd': ['is', 'am', 'was']},
        ];
        final tbItem = toBeQuiz[random.nextInt(toBeQuiz.length)];
        qText = tbItem['q'] as String;
        final opts = [tbItem['a'] as String, ...tbItem['d'] as List<String>]..shuffle();
        options = opts;
        correctIndex = opts.indexOf(tbItem['a'] as String);
        explanationText = 'Tata bahasa To Be / Auxiliary yang tepat adalah "${tbItem['a']}".';
        visualData = {'emoji': tbItem['emoji'], 'title': 'Grammar Card', 'subtitle': 'Tata Bahasa', 'colorHex': '#673AB7'};
        visualLabel = 'Petunjuk Tata Bahasa';
      }

      // -----------------------------------------------------------------------
      // 10. PRONOUNS & POSSESSIVES (I/My, He/His, She/Her)
      // -----------------------------------------------------------------------
      else if (tLower.contains('pronoun') ||
          tLower.contains('possessive') ||
          tLower.contains('i/my') ||
          tLower.contains('he/his') ||
          tLower.contains('she/her')) {
        levelTag = 'Sedang';
        final pronounPool = [
          {'q': 'Complete: "I have a new pencil. This is _____ pencil."', 'a': 'my', 'emoji': '✏️', 'd': ['his', 'her', 'their']},
          {'q': 'Complete: "He is my brother. _____ name is Budi."', 'a': 'His', 'emoji': '👦', 'd': ['Her', 'My', 'Our']},
          {'q': 'Complete: "She is a diligent girl. _____ bag is pink."', 'a': 'Her', 'emoji': '👧', 'd': ['His', 'He', 'Him']},
          {'q': 'Complete: "They are playing in the garden with _____ dog."', 'a': 'their', 'emoji': '🐕', 'd': ['her', 'his', 'my']},
          {'q': 'What is the subject pronoun for a boy or man?', 'a': 'He', 'emoji': '👨', 'd': ['She', 'It', 'We']},
        ];
        final pItem = pronounPool[random.nextInt(pronounPool.length)];
        qText = pItem['q'] as String;
        final opts = [pItem['a'] as String, ...pItem['d'] as List<String>]..shuffle();
        options = opts;
        correctIndex = opts.indexOf(pItem['a'] as String);
        explanationText = 'Kata ganti kepemilikan yang tepat adalah "${pItem['a']}".';
        visualData = {'emoji': pItem['emoji'], 'title': 'Pronouns & Possessives', 'subtitle': 'Kata Ganti Milik', 'colorHex': '#7209B7'};
        visualLabel = 'Petunjuk Tata Bahasa';
      }

      // -----------------------------------------------------------------------
      // 11. SINGULAR & PLURAL NOUNS
      // -----------------------------------------------------------------------
      else if (tLower.contains('singular') || tLower.contains('plural') || (tLower.contains('noun') && !tLower.contains('pronoun'))) {
        levelTag = 'Dasar';
        final pluralPool = [
          {'q': 'What is the plural form of the word "Book" (more than one book)?', 'a': 'Books', 'emoji': '📚', 'd': ['Bookes', 'Bookies', 'Booking']},
          {'q': 'Which article is correct: "_____ apple is on the table"?', 'a': 'An', 'emoji': '🍎', 'd': ['A', 'Two', 'These']},
          {'q': 'What is the plural form of the word "Box"?', 'a': 'Boxes', 'emoji': '📦', 'd': ['Boxs', 'Boxies', 'Boxer']},
          {'q': 'Which article is correct: "I see _____ cat in the garden"?', 'a': 'a', 'emoji': '🐱', 'd': ['an', 'these', 'many']},
          {'q': 'Complete: "There are three _____ swimming in the pond."', 'a': 'ducks', 'emoji': '🦆', 'd': ['duck', 'dukes', 'ducking']},
        ];
        final plItem = pluralPool[random.nextInt(pluralPool.length)];
        qText = plItem['q'] as String;
        final opts = [plItem['a'] as String, ...plItem['d'] as List<String>]..shuffle();
        options = opts;
        correctIndex = opts.indexOf(plItem['a'] as String);
        explanationText = 'Aturan tunggal/jamak yang tepat adalah "${plItem['a']}".';
        visualData = {'emoji': plItem['emoji'], 'title': 'Singular & Plural Nouns', 'subtitle': 'Tunggal & Jamak', 'colorHex': '#FF9800'};
        visualLabel = 'Petunjuk Benda';
      }

      // -----------------------------------------------------------------------
      // 12. PREPOSITIONS OF PLACE (IN, ON, UNDER, BESIDE)
      // -----------------------------------------------------------------------
      else if (tLower.contains('preposition') || tLower.contains('place') || tLower.contains('under') || tLower.contains('beside')) {
        levelTag = 'Sedang';
        final prepPool = [
          {'q': 'Where is the apple if it is inside the box?', 'a': 'In the box', 'emoji': '📥', 'd': ['On the box', 'Under the box', 'Behind the box']},
          {'q': 'The cat is sleeping beneath the chair. The cat is _____ the chair.', 'a': 'under', 'emoji': '🪑', 'd': ['on', 'in', 'above']},
          {'q': 'The book is resting flat on top of the desk. The book is _____ the desk.', 'a': 'on', 'emoji': '📖', 'd': ['under', 'in', 'behind']},
          {'q': 'Siti is standing next to Ani. Siti is _____ Ani.', 'a': 'beside', 'emoji': '👭', 'd': ['under', 'in', 'inside']},
          {'q': 'The car is parked in the space rear of the house. The car is _____ the house.', 'a': 'behind', 'emoji': '🏡', 'd': ['on', 'under', 'in front of']},
        ];
        final prItem = prepPool[random.nextInt(prepPool.length)];
        qText = prItem['q'] as String;
        final opts = [prItem['a'] as String, ...prItem['d'] as List<String>]..shuffle();
        options = opts;
        correctIndex = opts.indexOf(prItem['a'] as String);
        explanationText = 'Preposisi posisi tempat yang tepat adalah "${prItem['a']}".';
        visualData = {'emoji': prItem['emoji'], 'title': 'Prepositions of Place', 'subtitle': 'Posisi Tempat', 'colorHex': '#3F51B5'};
        visualLabel = 'Petunjuk Posisi';
      }

      // -----------------------------------------------------------------------
      // 13. SELF INTRODUCTION & EXPRESSING FEELINGS
      // -----------------------------------------------------------------------
      else if (tLower.contains('self') || tLower.contains('intro') || tLower.contains('feeling') || tLower.contains('feelings')) {
        levelTag = 'Dasar';
        final introPool = [
          {'q': 'How do you introduce yourself to a new classmate?', 'a': 'Hello, my name is $studentName', 'emoji': '👋', 'd': ['Good night, I am sleeping', 'Where is my pencil?', 'I don\'t like you']},
          {'q': 'How do you answer the question: "How are you today?"', 'a': 'I am fine, thank you', 'emoji': '😊', 'd': ['My name is Budi', 'I am 7 years old', 'It is a pencil']},
          {'q': 'What do you say when you want to drink water?', 'a': 'I am thirsty', 'emoji': '🥤', 'd': ['I am sleepy', 'I am angry', 'I am scared']},
          {'q': 'What do you say when you want to eat food?', 'a': 'I am hungry', 'emoji': '🍱', 'd': ['I am cold', 'I am happy', 'I am tired']},
          {'q': 'How do you tell someone your age in English?', 'a': 'I am seven years old', 'emoji': '🎂', 'd': ['I have seven apples', 'My house is seven', 'Seven o\'clock']},
        ];
        final inItem = introPool[random.nextInt(introPool.length)];
        qText = inItem['q'] as String;
        final opts = [inItem['a'] as String, ...inItem['d'] as List<String>]..shuffle();
        options = opts;
        correctIndex = opts.indexOf(inItem['a'] as String);
        explanationText = 'Ungkapan perkenalan / perasaan yang tepat adalah "${inItem['a']}".';
        visualData = {'emoji': inItem['emoji'], 'title': 'Self Intro & Feelings', 'subtitle': 'Perkenalan & Perasaan', 'colorHex': '#4361EE'};
        visualLabel = 'Petunjuk Percakapan';
      }

      // -----------------------------------------------------------------------
      // 14. ASKING & OFFERING HELP
      // -----------------------------------------------------------------------
      else if (tLower.contains('help') || tLower.contains('asking') || tLower.contains('offering') || tLower.contains('tolong')) {
        levelTag = 'Dasar';
        final helpPool = [
          {'q': 'Complete the polite request: "Can you _____ me carry these books, please?"', 'a': 'help', 'emoji': '🤝', 'd': ['eat', 'sleep', 'kick']},
          {'q': 'How do you politely reply when someone says "Thank you very much!"?', 'a': 'You are welcome', 'emoji': '💙', 'd': ['I am angry', 'Goodbye teacher', 'No, I don\'t']},
          {'q': 'Which sentence is used to offer help to a friend?', 'a': 'May I help you?', 'emoji': '🙋‍♂️', 'd': ['Give me your money', 'Don\'t talk to me', 'Where are you going?']},
          {'q': 'Complete the sentence: "Could you please _____ the door for me?"', 'a': 'open', 'emoji': '🚪', 'd': ['fly', 'bite', 'cook']},
          {'q': 'What magic word do you use when asking someone for help politely?', 'a': 'Please', 'emoji': '✨', 'd': ['Quickly', 'Never', 'Run']},
          {'q': 'Complete: "Thank you for _____ me with my homework, Sinan!"', 'a': 'helping', 'emoji': '📚', 'd': ['sleeping', 'eating', 'crying']},
        ];
        final hlItem = helpPool[random.nextInt(helpPool.length)];
        qText = hlItem['q'] as String;
        final opts = [hlItem['a'] as String, ...hlItem['d'] as List<String>]..shuffle();
        options = opts;
        correctIndex = opts.indexOf(hlItem['a'] as String);
        explanationText = 'Ungkapan meminta/menawarkan bantuan yang santun adalah "${hlItem['a']}".';
        visualData = {'emoji': hlItem['emoji'], 'title': 'Asking & Offering Help', 'subtitle': 'Tolong & Terima Kasih', 'colorHex': '#F72585'};
        visualLabel = 'Petunjuk Kesopanan';
      }

      // -----------------------------------------------------------------------
      // 15. GIVING COMMANDS & REQUESTS
      // -----------------------------------------------------------------------
      else if (tLower.contains('command') || tLower.contains('commands') || tLower.contains('request') || tLower.contains('requests') || tLower.contains('perintah')) {
        levelTag = 'Sedang';
        final commandPool = [
          {'q': 'What does the teacher say when asking students to rise from their chairs?', 'a': 'Stand up, please', 'emoji': '🧍', 'd': ['Sit down quietly', 'Sleep now', 'Go home']},
          {'q': 'What command is used to tell students not to make noise in the library?', 'a': 'Please be quiet', 'emoji': '🤫', 'd': ['Sing loudly', 'Run fast', 'Eat snacks']},
          {'q': 'What does the teacher say when you want to answer a question?', 'a': 'Raise your hand', 'emoji': '🙋‍♀️', 'd': ['Close your eyes', 'Kick the ball', 'Wash your hands']},
          {'q': 'What prohibition is used when children run inside the school hallway?', 'a': 'Don\'t run!', 'emoji': '⚠️', 'd': ['Run faster!', 'Jump high!', 'Dance now!']},
          {'q': 'What command asks students to start reading on page 15?', 'a': 'Open your book to page 15', 'emoji': '📖', 'd': ['Close your book', 'Throw your book', 'Draw on the wall']},
        ];
        final cmItem = commandPool[random.nextInt(commandPool.length)];
        qText = cmItem['q'] as String;
        final opts = [cmItem['a'] as String, ...cmItem['d'] as List<String>]..shuffle();
        options = opts;
        correctIndex = opts.indexOf(cmItem['a'] as String);
        explanationText = 'Kalimat instruksi/perintah yang tepat adalah "${cmItem['a']}".';
        visualData = {'emoji': cmItem['emoji'], 'title': 'Classroom Commands', 'subtitle': 'Kalimat Perintah & Aturan', 'colorHex': '#3F51B5'};
        visualLabel = 'Petunjuk Instruksi';
      }

      // -----------------------------------------------------------------------
      // 16. DESCRIBING PEOPLE, PLACES & THINGS
      // -----------------------------------------------------------------------
      else if (tLower.contains('describing people') || (tLower.contains('describing') && !tLower.contains('reading') && !tLower.contains('paragraph')) || tLower.contains('adjective')) {
        levelTag = 'Sedang';
        final descPool = [
          {'q': 'Which adjective describes a giraffe with a very long neck?', 'a': 'Tall', 'emoji': '🦒', 'd': ['Short', 'Fat', 'Tiny']},
          {'q': 'What is the opposite of the adjective "Big" (Besar)?', 'a': 'Small', 'emoji': '🐭', 'd': ['Huge', 'Tall', 'Fast']},
          {'q': 'Complete: "My English teacher is very _____ and smart."', 'a': 'kind', 'emoji': '👩‍🏫', 'd': ['salty', 'sour', 'rough']},
          {'q': 'Which word describes a bright sunny day at the beach?', 'a': 'Warm', 'emoji': '☀️', 'd': ['Freezing', 'Snowy', 'Dark']},
          {'q': 'Complete: "The cheetah runs very _____ across the savanna."', 'a': 'fast', 'emoji': '🐆', 'd': ['slow', 'heavy', 'tired']},
        ];
        final dsItem = descPool[random.nextInt(descPool.length)];
        qText = dsItem['q'] as String;
        final opts = [dsItem['a'] as String, ...descPool.map((e) => e['a'] as String).where((e) => e != dsItem['a']).take(3)]..shuffle();
        if (opts.length < 4) {
          opts.addAll(dsItem['d'] as List<String>);
          opts.length = 4;
        }
        options = opts;
        correctIndex = opts.indexOf(dsItem['a'] as String);
        explanationText = 'Kata sifat yang tepat adalah "${dsItem['a']}".';
        visualData = {'emoji': dsItem['emoji'], 'title': 'Describing Things', 'subtitle': 'Kata Sifat (Adjective)', 'colorHex': '#FF9800'};
        visualLabel = 'Petunjuk Sifat';
      }

      // -----------------------------------------------------------------------
      // 17. WORLD CULTURE & LANDMARKS
      // -----------------------------------------------------------------------
      else if (tLower.contains('culture') ||
          tLower.contains('landmark') ||
          tLower.contains('passport') ||
          tLower.contains('indonesia') ||
          tLower.contains('singapura') ||
          tLower.contains('malaysia') ||
          tLower.contains('jepang') ||
          (tLower.contains('inggris') && !tLower.contains('bahasa inggris')) ||
          tLower.contains('united kingdom') ||
          tLower.contains('london') ||
          tLower.contains('amerika') ||
          tLower.contains('kanada') ||
          tLower.contains('australia')) {
        levelTag = 'HOTS';
        final culturePool = [
          {'q': 'Where is the famous landmark "Monas" located?', 'a': 'Jakarta, Indonesia', 'emoji': '🇮🇩', 'd': ['Tokyo, Japan', 'London, UK', 'Sydney, Australia']},
          {'q': 'Where is the famous clock tower "Big Ben" located?', 'a': 'London, United Kingdom', 'emoji': '🇬🇧', 'd': ['Tokyo, Japan', 'Jakarta, Indonesia', 'Paris, France']},
          {'q': 'Which country is famous for the Eiffel Tower?', 'a': 'France', 'emoji': '🇫🇷', 'd': ['Italy', 'Spain', 'Germany']},
          {'q': 'What is the famous jumping animal from Australia?', 'a': 'Kangaroo', 'emoji': '🦘', 'd': ['Panda', 'Lion', 'Penguin']},
          {'q': 'Where is Merlion Park located?', 'a': 'Singapore', 'emoji': '🇸🇬', 'd': ['Malaysia', 'Japan', 'Indonesia']},
          {'q': 'Where are the Petronas Twin Towers located?', 'a': 'Malaysia', 'emoji': '🇲🇾', 'd': ['Singapore', 'Thailand', 'Vietnam']},
          {'q': 'Which mountain is the iconic symbol of Japan?', 'a': 'Mount Fuji', 'emoji': '🗻', 'd': ['Mount Everest', 'Mount Bromo', 'Mount Kinabalu']},
          {'q': 'Where is the Statue of Liberty located?', 'a': 'New York, USA', 'emoji': '🗽', 'd': ['Toronto, Canada', 'London, UK', 'Sydney, Australia']},
        ];
        final cItem = culturePool[random.nextInt(culturePool.length)];
        qText = cItem['q'] as String;
        final opts = [cItem['a'] as String, ...cItem['d'] as List<String>]..shuffle();
        options = opts;
        correctIndex = opts.indexOf(cItem['a'] as String);
        explanationText = 'Pengetahuan umum budaya/landmark: "${cItem['a']}".';
        visualData = {'emoji': cItem['emoji'], 'title': 'World Culture & Passport', 'subtitle': 'Landmark / Simbol Negara', 'colorHex': '#FF5722'};
        visualLabel = 'Petunjuk Landmark';
      }

      // -----------------------------------------------------------------------
      // 18. GENERAL DEFAULT
      // -----------------------------------------------------------------------
      else {
        if (isReadingTopic) {
          levelTag = 'Sedang';
          visualType = 'english_reading_passage';
          final allReading = _getReadingQuestions();
          final rq = allReading[random.nextInt(allReading.length)];
          qText = rq['q'] as String;
          final opts = [rq['a'] as String, ...(rq['d'] as List<String>)]..shuffle();
          options = opts;
          correctIndex = opts.indexOf(rq['a'] as String);
          explanationText = rq['exp'] as String;
          visualData = {
            'storyTitle': rq['storyTitle'],
            'storyText': rq['storyText'],
            'emoji': rq['emoji'],
            'colorHex': rq['colorHex'],
          };
          visualLabel = 'Teks Bacaan Cerita';
        } else {
          levelTag = 'Sedang';
          final vItem = _vocabPool[random.nextInt(_vocabPool.length)];
          qText = 'What is the English word for "${vItem['id']}"?';
          final opts = [vItem['en']!];
          int optTries = 0;
          while (opts.length < 4 && optTries < 40) {
            optTries++;
            final randV = _vocabPool[random.nextInt(_vocabPool.length)];
            if (!opts.contains(randV['en'])) opts.add(randV['en']!);
          }
          opts.shuffle();
          options = opts;
          correctIndex = opts.indexOf(vItem['en']!);
          explanationText = 'Bahasa Inggris dari "${vItem['id']}" adalah "${vItem['en']}".';
          visualType = 'english_vocab_card';
          visualData = {
            'emoji': vItem['emoji'],
            'title': 'English Practice',
            'subtitle': 'Kosakata ${vItem['category']}',
            'colorHex': '#4CC9F0',
          };
          visualLabel = 'Gambar Petunjuk';
        }
      }

      // Deduplication check
      if (seenQuestionTexts.contains(qText)) {
        continue;
      }
      seenQuestionTexts.add(qText);

      questions.add(
        Question(
          id: 'gen_eng_${DateTime.now().millisecondsSinceEpoch}_${questions.length}',
          gradeLevel: gradeLevel,
          classNum: classNum,
          subject: 'Bahasa Inggris',
          topic: topic,
          level: levelTag,
          questionText: qText,
          options: options,
          correctAnswerIndex: correctIndex,
          explanation: explanationText,
          visualType: visualType,
          visualData: visualData,
          visualLabel: visualLabel,
          isCustom: true,
        ),
      );
    }

    // -------------------------------------------------------------------------
    // TOPIC-AWARE DYNAMIC NON-REPETITIVE FALLBACK BUILDER
    // -------------------------------------------------------------------------
    int fillIndex = 0;
    while (questions.length < count && fillIndex < 100) {
      fillIndex++;
      if (isReadingTopic) {
        final allReading = _getReadingQuestions();
        final rq = allReading[(fillIndex * 3 + random.nextInt(5)) % allReading.length];
        String fillQ = rq['q'] as String;
        if (seenQuestionTexts.contains(fillQ)) {
          fillQ = 'Reading Practice #$fillIndex: ${rq['q']}';
        }
        seenQuestionTexts.add(fillQ);
        final opts = [rq['a'] as String, ...(rq['d'] as List<String>)]..shuffle();
        questions.add(
          Question(
            id: 'gen_eng_reading_fill_${DateTime.now().millisecondsSinceEpoch}_$fillIndex',
            gradeLevel: gradeLevel,
            classNum: classNum,
            subject: 'Bahasa Inggris',
            topic: topic,
            level: 'Sedang',
            questionText: fillQ,
            options: opts,
            correctAnswerIndex: opts.indexOf(rq['a'] as String),
            explanation: rq['exp'] as String,
            visualType: 'english_reading_passage',
            visualData: {
              'storyTitle': rq['storyTitle'],
              'storyText': rq['storyText'],
              'emoji': rq['emoji'],
              'colorHex': rq['colorHex'],
            },
            visualLabel: 'Teks Bacaan Cerita',
            isCustom: true,
          ),
        );
      } else {
        final fillName = _studentNames[fillIndex % _studentNames.length];
        final vItem = _vocabPool[(fillIndex * 3 + random.nextInt(5)) % _vocabPool.length];

        final fillQ = '$fillName\'s Practice #$fillIndex ($topic): What is the English word for "${vItem['id']}"?';

        if (!seenQuestionTexts.contains(fillQ)) {
          seenQuestionTexts.add(fillQ);
          final opts = [vItem['en']!];
          int optTries = 0;
          while (opts.length < 4 && optTries < 40) {
            optTries++;
            final randV = _vocabPool[random.nextInt(_vocabPool.length)];
            if (!opts.contains(randV['en'])) opts.add(randV['en']!);
          }
          opts.shuffle();

          questions.add(
            Question(
              id: 'gen_eng_fill_${DateTime.now().millisecondsSinceEpoch}_$fillIndex',
              gradeLevel: gradeLevel,
              classNum: classNum,
              subject: 'Bahasa Inggris',
              topic: topic,
              level: 'Sedang',
              questionText: fillQ,
              options: opts,
              correctAnswerIndex: opts.indexOf(vItem['en']!),
              explanation: 'Bahasa Inggris dari "${vItem['id']}" adalah "${vItem['en']}".',
              visualType: 'english_vocab_card',
              visualData: {
                'emoji': vItem['emoji'],
                'title': 'English Practice',
                'subtitle': 'Kosakata ${vItem['category']}',
                'colorHex': '#4CC9F0',
              },
              visualLabel: 'Gambar Petunjuk',
              isCustom: true,
            ),
          );
        }
      }
    }

    questions.shuffle();
    return questions;
  }
}
