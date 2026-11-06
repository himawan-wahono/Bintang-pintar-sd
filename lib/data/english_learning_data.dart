import '../models/english_theme_model.dart';

class EnglishLearningData {
  static const List<EnglishTheme> themes = [
    // -------------------------------------------------------------------------
    // TEMA 1: ALPHABET, PHONICS & VOCABULARY
    // -------------------------------------------------------------------------
    EnglishTheme(
      id: 'tema_eng_vocab',
      title: 'Alphabet, Phonics & Basic Vocabulary',
      description: 'Pengucapan abjad, angka, warna, anggota keluarga, dan kata benda sekitar.',
      iconEmoji: '🔤',
      themeColorHex: '#4CC9F0',
      topics: [
        EnglishTopic(
          id: 'eng_phonics_alphabet',
          title: 'Phonics, Alphabet & Basic Vocabulary',
          description: 'Cara membaca huruf A-Z, bunyi phonics, dan ejaan kata dasar.',
          summaryContent:
              'Alphabet A to Z has 26 letters. Phonics helps you pronounce words correctly:\n'
              '• A is for Apple (/æ/ - Apel)\n'
              '• B is for Ball (/b/ - Bola)\n'
              '• C is for Cat (/k/ - Kucing)\n'
              '• Vowels (Huruf Vokal): A, E, I, O, U.',
          keyPhrases: [
            'How do you spell your name?',
            'A-P-P-L-E = Apple',
            'Vowels = A, E, I, O, U',
          ],
          exampleSentence: 'How do you spell "BOOK"? B - O - O - K.',
          exampleTranslation: 'Bagaimana cara kamu mengeja "BOOK"? B - O - O - K.',
        ),
        EnglishTopic(
          id: 'eng_numbers_colors',
          title: 'Numbers, Colors & Shapes',
          description: 'Mengenal angka 1-100, warna (red, blue, yellow), dan bentuk geometri.',
          summaryContent:
              '• Numbers (Angka): One (1), Two (2), Ten (10), Twenty (20), One Hundred (100).\n'
              '• Colors (Warna): Red (Merah), Blue (Biru), Green (Hijau), Yellow (Kuning), Purple (Ungu).\n'
              '• Shapes (Bentuk): Circle (Lingkaran), Square (Persegi), Triangle (Segitiga).',
          keyPhrases: [
            'What color is it? It is red.',
            'How many apples are there? There are three apples.',
          ],
          exampleSentence: 'What color is the sky? The sky is blue.',
          exampleTranslation: 'Apa warna langit? Langit berwarna biru.',
        ),
        EnglishTopic(
          id: 'eng_family_greetings',
          title: 'Family Members & Greetings',
          description: 'Anggota keluarga (Father, Mother) dan ucapan salam (Good Morning).',
          summaryContent:
              '• Family Members: Father (Ayah), Mother (Ibu), Brother (Saudara Laki-laki), Sister (Saudara Perempuan), Grandfather (Kakek), Grandmother (Nenek).\n'
              '• Greetings (Ucapan Salam):\n'
              '  - Good Morning (Selamat Pagi)\n'
              '  - Good Afternoon (Selamat Siang/Sore)\n'
              '  - Good Evening (Selamat Malam)\n'
              '  - Nice to meet you! (Senang bertemu denganmu!)',
          keyPhrases: [
            'Good morning, Teacher!',
            'This is my mother and this is my father.',
            'Nice to meet you!',
          ],
          exampleSentence: 'Good morning, My name is Sinan. This is my sister, Syalumi.',
          exampleTranslation: 'Selamat pagi, Nama saya Sinan. Ini adalah saudara perempuan saya, Syalumi.',
        ),
        EnglishTopic(
          id: 'eng_animals_food',
          title: 'Animals, Fruits & Food',
          description: 'Nama hewan (Elephant, Lion), buah-buahan (Banana), dan makanan favorit.',
          summaryContent:
              '• Animals: Lion (Singa), Elephant (Gajah), Monkey (Monyet), Rabbit (Kelinci), Bird (Burung).\n'
              '• Fruits: Apple (Apel), Banana (Pisang), Orange (Jeruk), Mango (Mangga).\n'
              '• Expressing Likes: "I like apples!" (Saya suka apel!), "My favorite food is fried rice."',
          keyPhrases: [
            'What is your favorite food?',
            'I like bananas and apples.',
            'The elephant is very big!',
          ],
          exampleSentence: 'What is your favorite animal? My favorite animal is the rabbit.',
          exampleTranslation: 'Apa hewan favoritmu? Hewan favorit saya adalah kelinci.',
        ),
      ],
    ),

    // -------------------------------------------------------------------------
    // TEMA 2: SCHOOL, HOME & DAILY ROUTINES
    // -------------------------------------------------------------------------
    EnglishTheme(
      id: 'tema_eng_school_home',
      title: 'School, Home & Daily Routines',
      description: 'Benda di kelas, bagian rumah, aktivitas sehari-hari, dan hobi.',
      iconEmoji: '🏫',
      themeColorHex: '#4361EE',
      topics: [
        EnglishTopic(
          id: 'eng_classroom_objects',
          title: 'Classroom & School Objects',
          description: 'Mengenal benda sekolah (Pencil, Book, Eraser, Ruler, Bag).',
          summaryContent:
              'Classroom Objects:\n'
              '• Book (Buku), Pencil (Pensil), Eraser (Penghapus), Ruler (Penggaris), Bag (Tas).\n'
              '• Whiteboard (Papan Tulis), Desk (Meja), Chair (Kursi).\n'
              '• Demonstratives: "This is a book" (Ini sebuah buku), "That is a ruler" (Itu sebuah penggaris).',
          keyPhrases: [
            'This is my new school bag.',
            'May I borrow your pencil, please?',
            'Open your book to page 10.',
          ],
          exampleSentence: 'May I borrow your ruler, please? Yes, of course!',
          exampleTranslation: 'Bolehkah saya meminjam penggarismu? Ya, tentu saja!',
        ),
        EnglishTopic(
          id: 'eng_house_furniture',
          title: 'House Rooms & Furniture',
          description: 'Ruangan di rumah (Bedroom, Kitchen) dan perabotannya.',
          summaryContent:
              'Rooms in the House:\n'
              '• Living Room (Ruang Tamu) - Sofa, Television.\n'
              '• Bedroom (Kamar Tidur) - Bed, Pillow, Blanket.\n'
              '• Kitchen (Dapur) - Stove, Refrigerator, Plate.\n'
              '• Bathroom (Kamar Mandi) - Soap, Towel, Mirror.',
          keyPhrases: [
            'Where is my bag? It is in the bedroom.',
            'My mother is cooking in the kitchen.',
          ],
          exampleSentence: 'Where is Syalumi? She is reading a book in the living room.',
          exampleTranslation: 'Di manakah Syalumi? Dia sedang membaca buku di ruang tamu.',
        ),
        EnglishTopic(
          id: 'eng_daily_routines',
          title: 'Simple Present Tense & Daily Routines',
          description: 'Aktivitas harian (Wake up, Go to school, Study) dan waktu jam.',
          summaryContent:
              'Daily Routines (Aktivitas Sehari-hari):\n'
              '• Wake up (Bangun tidur) at 06:00 AM.\n'
              '• Take a bath (Mandi) & Have breakfast (Sarapan).\n'
              '• Go to school (Pergi ke sekolah) & Study (Belajar).\n'
              '• Telling Time: "What time is it?" -> "It is seven o\'clock."',
          keyPhrases: [
            'What time do you wake up?',
            'I wake up at six o\'clock in the morning.',
            'What time is it? It is 07:30.',
          ],
          exampleSentence: 'I go to school at seven o\'clock every morning.',
          exampleTranslation: 'Saya pergi ke sekolah pada pukul tujuh setiap pagi.',
        ),
        EnglishTopic(
          id: 'eng_hobbies_free_time',
          title: 'Hobbies & Free Time Activities',
          description: 'Hobi (Reading, Swimming, Playing Football, Drawing).',
          summaryContent:
              'Hobbies (Kegemaran):\n'
              '• Reading (Membaca), Swimming (Berenang), Singing (Bernyanyi).\n'
              '• Playing Football (Bermain Sepak Bola), Drawing (Menggambar), Cycling (Bersepeda).\n'
              '• Asking about hobbies: "What is your hobby?" -> "My hobby is reading books."',
          keyPhrases: [
            'What is your hobby?',
            'My hobby is playing football.',
            'She likes drawing and painting.',
          ],
          exampleSentence: 'What do you like to do in your free time? I like cycling in the park.',
          exampleTranslation: 'Apa yang suka kamu lakukan di waktu luang? Saya suka bersepeda di taman.',
        ),
      ],
    ),

    // -------------------------------------------------------------------------
    // TEMA 3: GRAMMAR & SENTENCE STRUCTURE
    // -------------------------------------------------------------------------
    EnglishTheme(
      id: 'tema_eng_grammar',
      title: 'Grammar & Sentence Structure',
      description: 'Struktur tata bahasa SD (To Be, Pronouns, Singular/Plural, Prepositions).',
      iconEmoji: '📝',
      themeColorHex: '#7209B7',
      topics: [
        EnglishTopic(
          id: 'eng_to_be_present',
          title: 'Simple Present Tense (Is/Am/Are, Do/Does)',
          description: 'Penggunaan to be (Am, Is, Are) dan kata kerja bantu (Do/Does).',
          summaryContent:
              'To Be (Is / Am / Are):\n'
              '• I ➔ am (I am a student).\n'
              '• He / She / It / Singular ➔ is (He is a teacher, Syalumi is happy).\n'
              '• You / We / They / Plural ➔ are (They are playing, We are ready).\n'
              'Do / Does:\n'
              '• Do: I, You, We, They ("Do you like apples?").\n'
              '• Does: He, She, It ("Does he play football?").',
          keyPhrases: [
            'I am a student at SD Merdeka.',
            'She is very smart and kind.',
            'They are happy today.',
          ],
          exampleSentence: 'She is a diligent student. They are playing in the playground.',
          exampleTranslation: 'Dia adalah murid yang rajin. Mereka sedang bermain di halaman.',
        ),
        EnglishTopic(
          id: 'eng_pronouns_possessives',
          title: 'Pronouns & Possessives (I/My, He/His, She/Her)',
          description: 'Kata ganti orang (I, You, He, She) dan kepemilikan (My, Your, His, Her).',
          summaryContent:
              'Subject Pronoun vs Possessive Adjective:\n'
              '• I (Saya) ➔ My (Milik saya) -> My book (Bukuku).\n'
              '• You (Kamu) ➔ Your (Milikmu) -> Your pencil (Pensilmu).\n'
              '• He (Dia Laki-laki) ➔ His (Miliknya) -> His bag (Tasnya).\n'
              '• She (Dia Perempuan) ➔ Her (Miliknya) -> Her cat (Kucingnya).\n'
              '• They (Mereka) ➔ Their (Milik mereka) -> Their house (Rumah mereka).',
          keyPhrases: [
            'This is my book.',
            'Is that your bicycle?',
            'His name is Sinan and her name is Syalumi.',
          ],
          exampleSentence: 'This is my bag and that is her pencil case.',
          exampleTranslation: 'Ini adalah tas saya dan itu adalah kotak pensilnya.',
        ),
        EnglishTopic(
          id: 'eng_singular_plural',
          title: 'Singular & Plural Nouns',
          description: 'Benda tunggal (A/An) dan benda jamak (Akhiran -s/-es).',
          summaryContent:
              'Singular (Tunggal = 1) vs Plural (Jamak > 1):\n'
              '• Gunakan "A" untuk bunyi konsonan (A book, A cat).\n'
              '• Gunakan "An" untuk bunyi vokal A,E,I,O,U (An apple, An elephant).\n'
              '• Tambahkan "-s" atau "-es" untuk benda jamak:\n'
              '  - One book ➔ Two books (+s)\n'
              '  - One box ➔ Three boxes (+es)',
          keyPhrases: [
            'A book (1 buku) vs Two books (2 buku)',
            'An apple (1 apel) vs Five apples (5 apel)',
          ],
          exampleSentence: 'I have an apple and two oranges in my lunchbox.',
          exampleTranslation: 'Saya membawa sebuah apel dan dua buah jeruk di kotak makan saya.',
        ),
        EnglishTopic(
          id: 'eng_prepositions_place',
          title: 'Prepositions of Place (In, On, Under, Beside)',
          description: 'Kata depan penunjuk posisi tempat (Di dalam, Di atas, Di bawah, Di samping).',
          summaryContent:
              'Prepositions of Place (Posisi Tempat):\n'
              '• IN = Di dalam (The apple is in the box).\n'
              '• ON = Di atas menempel (The book is on the table).\n'
              '• UNDER = Di bawah (The cat is under the chair).\n'
              '• BESIDE / NEXT TO = Di samping (Syalumi is sitting beside Sinan).\n'
              '• IN FRONT OF = Di depan | BEHIND = Di belakang.',
          keyPhrases: [
            'Where is the cat? The cat is under the table.',
            'The book is on the desk.',
            'The school is in front of the park.',
          ],
          exampleSentence: 'Where is the cat? The cat is sleeping under the table.',
          exampleTranslation: 'Di manakah kucing itu? Kucing itu sedang tidur di bawah meja.',
        ),
      ],
    ),

    // -------------------------------------------------------------------------
    // TEMA 4: CONVERSATION & SOCIAL SKILLS
    // -------------------------------------------------------------------------
    EnglishTheme(
      id: 'tema_eng_conversation',
      title: 'Conversation & Social Skills',
      description: 'Percakapan sehari-hari, perkenalan diri, meminta tolong, dan kalimat perintah.',
      iconEmoji: '💬',
      themeColorHex: '#F72585',
      topics: [
        EnglishTopic(
          id: 'eng_self_intro',
          title: 'Self Introduction & Expressing Feelings',
          description: 'Memperkenalkan diri sendiri, umur, dan mengungkapkan perasaan (Happy, Sad).',
          summaryContent:
              'Self Introduction (Perkenalan Diri):\n'
              '• "Hello! My name is Sinan. I am 9 years old. I am in the 3rd grade of SD."\n'
              'Expressing Feelings (Ungkapan Perasaan):\n'
              '• Happy (Senang), Sad (Sedih), Hungry (Lapar), Thirsty (Haus), Tired (Lelah).\n'
              '• "How are you today?" -> "I am very happy today!"',
          keyPhrases: [
            'Hello! My name is Syalumi.',
            'I am 8 years old.',
            'How are you? I am fine, thank you!',
          ],
          exampleSentence: 'Hello, my name is Sinan. I am nine years old and I am very happy to meet you!',
          exampleTranslation: 'Halo, nama saya Sinan. Saya berumur sembilan tahun dan sangat senang bertemu denganku!',
        ),
        EnglishTopic(
          id: 'eng_asking_help',
          title: 'Asking & Offering Help',
          description: 'Ungkapan meminta bantuan (Can you help me?) dan kata sopan (Please, Thank you).',
          summaryContent:
              'Polite Expressions (Ungkapan Kesopanan):\n'
              '• Asking for Help: "Can you help me, please?", "Could you open the door?"\n'
              '• Offering Help: "Can I help you?", "May I help you carry the books?"\n'
              '• Always use "Please" (Tolong) and say "Thank you" (Terima kasih) or "You\'re welcome" (Sama-sama).',
          keyPhrases: [
            'Can you help me, please?',
            'Thank you very much!',
            'You\'re welcome!',
          ],
          exampleSentence: 'Can you help me clean the whiteboard, please? Sure, no problem!',
          exampleTranslation: 'Bisa tolong bantu saya membersihkan papan tulis? Tentu, tidak masalah!',
        ),
        EnglishTopic(
          id: 'eng_giving_commands',
          title: 'Giving Commands & Requests',
          description: 'Kalimat perintah & larangan di kelas (Stand up, Sit down, Don\'t run).',
          summaryContent:
              'Commands (Kalimat Perintah) & Imperatives:\n'
              '• Stand up (Berdiri) | Sit down (Duduk).\n'
              '• Listen carefully (Dengarkan dengan seksama) | Raise your hand (Angkat tanganmu).\n'
              '• Prohibitions (Larangan): "Don\'t run!" (Jangan berlari!), "Don\'t shout!" (Jangan berteriak!).',
          keyPhrases: [
            'Raise your hand if you know the answer.',
            'Please sit down quietly.',
            'Don\'t throw trash on the floor!',
          ],
          exampleSentence: 'Please raise your hand if you want to ask a question.',
          exampleTranslation: 'Tolong angkat tanganmu jika kamu ingin mengajukan pertanyaan.',
        ),
        EnglishTopic(
          id: 'eng_describing_people',
          title: 'Describing People, Places & Things',
          description: 'Kata sifat/Adjectives (Big, Small, Tall, Beautiful, Smart).',
          summaryContent:
              'Adjectives (Kata Sifat) untuk mendeskripsikan benda/orang:\n'
              '• Size: Big (Besar) vs Small (Kecil), Tall (Tinggi) vs Short (Pendek).\n'
              '• Character: Smart (Pintar), Kind (Baik Hati), Diligent (Rajin).\n'
              '• Sentence Pattern: [Subject] + [To Be] + [Adjective]\n'
              '  - "Syalumi is smart and diligent." (Syalumi pintar dan rajin).\n'
              '  - "The giraffe is tall." (Zarafah itu tinggi).',
          keyPhrases: [
            'He is a smart and diligent boy.',
            'The elephant is big, but the mouse is small.',
          ],
          exampleSentence: 'My English teacher is very kind and smart.',
          exampleTranslation: 'Guru Bahasa Inggris saya sangat baik hati dan pintar.',
        ),
      ],
    ),

    // -------------------------------------------------------------------------
    // TEMA 5: READING COMPREHENSION & STORIES
    // -------------------------------------------------------------------------
    EnglishTheme(
      id: 'tema_eng_reading',
      title: 'Reading Comprehension & Stories',
      description: 'Membaca cerita pendek, fabel hewan, teks deskriptif, dan paspor budaya.',
      iconEmoji: '📖',
      themeColorHex: '#3F37C9',
      topics: [
        EnglishTopic(
          id: 'eng_short_stories',
          title: 'Short Story & Fables',
          description: 'Membaca dongeng fabel hewan pendek dan menemukan pesan moralnya.',
          summaryContent:
              'Reading Fables (Membaca Dongeng Hewan):\n'
              '• Example Story: "The Ant and the Grasshopper" (Semut dan Belalang).\n'
              '• Tips for Reading:\n'
              '  1. Read the text slowly.\n'
              '  2. Identify the main characters (Who is in the story?).\n'
              '  3. Find the moral message (Pesan moral kebaikan).',
          keyPhrases: [
            'Who is the main character in the story?',
            'What is the moral value of the fable?',
          ],
          exampleSentence: 'The hardworking ant stored food for the winter while the lazy grasshopper sang all day.',
          exampleTranslation: 'Semut yang bekerja keras menyimpan makanan untuk musim dingin sementara belalang yang malas bernyanyi sepanjang hari.',
        ),
        EnglishTopic(
          id: 'eng_descriptive_reading',
          title: 'Descriptive Paragraph Reading',
          description: 'Membaca paragraf deskripsi tentang hewan peliharaan atau sekolah.',
          summaryContent:
              'Descriptive Text (Teks Deskripsi):\n'
              'Teks yang menggambarkan benda/tempat/hewan secara detail.\n'
              'Example Paragraph:\n'
              '"I have a cat. Its name is Milo. It has soft white fur and blue eyes. Milo loves to eat fish and play with yarn. I love Milo very much."',
          keyPhrases: [
            'What is the text about?',
            'What color is Milo\'s fur?',
          ],
          exampleSentence: 'Milo has soft white fur and loves eating fresh fish every morning.',
          exampleTranslation: 'Milo memiliki bulu putih yang lembut dan suka makan ikan segar setiap pagi.',
        ),
        EnglishTopic(
          id: 'eng_culture_passports',
          title: 'World Culture & Landmark Passports',
          description: 'Mengenal negara-negara paspor (Indonesia, UK, USA, Australia, Japan).',
          summaryContent:
              'World Tour Passport Learning:\n'
              '• Indonesia 🇮🇩: Monas in Jakarta, Borobudur Temple in Magelang.\n'
              '• United Kingdom 🇬🇧: Big Ben clock tower in London.\n'
              '• Japan 🇯🇵: Mount Fuji and Cherry Blossom (Sakura).\n'
              '• Australia 🇦🇺: Kangaroo and Sydney Opera House.\n'
              '• Sentence: "I want to visit Big Ben in London, United Kingdom!"',
          keyPhrases: [
            'Where is Big Ben located? Big Ben is in London, UK.',
            'Kangaroos are native animals of Australia.',
          ],
          exampleSentence: 'Big Ben is a famous clock tower in London, United Kingdom.',
          exampleTranslation: 'Big Ben adalah menara jam terkenal yang berada di London, Inggris.',
        ),
      ],
    ),
  ];
}
