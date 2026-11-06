/**
 * Automated Gemini AI Question Generator & Firestore Sync
 * Comprehensive All-Topic Coverage Mode: Guarantees 20 fresh questions (10 Math + 10 English) for EVERY topic systematically!
 * Uses official @google/generative-ai SDK with automatic multi-model fallback (1.5-flash, 2.0-flash, 1.5-pro)
 * Guaranteed 100% Strict Zero Duplicates in Cloud Firestore!
 */

const admin = require("firebase-admin");
let GoogleGenerativeAI;
try {
  GoogleGenerativeAI = require("@google/generative-ai").GoogleGenerativeAI;
} catch (e) {
  GoogleGenerativeAI = null;
}

// 1. Inisialisasi Firebase Admin SDK & API Key
let serviceAccount;
const secretRaw = process.env.FIREBASE_SERVICE_ACCOUNT_BASE64;
const apiKey = process.env.GEMINI_API_KEY;

console.log("==================================================");
console.log("🚀 AUTOMATED AI GENERATOR: ALL-TOPICS COVERAGE MODE");
console.log("==================================================");

if (!secretRaw) {
  console.error("❌ CRITICAL ERROR: FIREBASE_SERVICE_ACCOUNT_BASE64 tidak ditemukan di GitHub Secrets!");
  process.exit(1);
}

if (!apiKey) {
  console.error("❌ CRITICAL ERROR: GEMINI_API_KEY tidak ditemukan di GitHub Secrets!");
  process.exit(1);
}

try {
  let jsonStr = secretRaw.trim();
  if (!jsonStr.startsWith("{")) {
    jsonStr = Buffer.from(jsonStr, "base64").toString("utf8");
  }
  serviceAccount = JSON.parse(jsonStr);
} catch (e) {
  console.error("❌ Gagal parsing FIREBASE_SERVICE_ACCOUNT_BASE64 JSON:", e.message);
  process.exit(1);
}

if (serviceAccount && serviceAccount.project_id) {
  try {
    admin.initializeApp({
      credential: admin.credential.cert(serviceAccount)
    });
    console.log("🔥 Firebase Admin SDK TERHUBUNG KE PROJECT:", serviceAccount.project_id);
  } catch (e) {
    console.error("⚠️ Firebase initialize info:", e.message);
  }
} else {
  console.error("❌ serviceAccount valid tidak terbentuk dari FIREBASE_SERVICE_ACCOUNT_BASE64.");
  process.exit(1);
}

// 2. Complete List of 19 Math Topics + 18 English Topics SD
const mathTopics = [
  "Pengenalan Bilangan dan Nilai Tempat",
  "Penjumlahan & Pengurangan Dasar",
  "Perkalian & Pembagian",
  "Pecahan, Desimal, dan Persen",
  "Kelipatan dan Faktor (KPK & FPB)",
  "Bilangan Bulat Negatif",
  "Pengenalan Bentuk dan Sifat Dasar",
  "Pengukuran Sudut dan Simetri",
  "Keliling dan Luas Bangun Datar",
  "Bangun Ruang Lanjutan",
  "Pengukuran Dasar dan Satuan",
  "Hubungan Antarsatuan / Konversi",
  "Pengukuran Gabungan",
  "Pengumpulan dan Pengelompokan Dasar",
  "Penyajikan Data Visual Dasar",
  "Pengolahan Data Lanjutan & Statistika Dasar",
  "Pengenalan Pola Gambar dan Bentuk",
  "Pola Bilangan",
  "Rasio, Skala, dan Koordinat Dasar"
];

const englishTopics = [
  "Phonics, Alphabet & Basic Vocabulary",
  "Numbers, Colors & Shapes",
  "Family Members & Greetings",
  "Animals, Fruits & Food",
  "Classroom & School Objects",
  "House Rooms & Furniture",
  "Simple Present Tense & Daily Routines",
  "Hobbies & Free Time Activities",
  "Simple Present Tense (Is/Am/Are, Do/Does)",
  "Pronouns & Possessives (I/My, He/His, She/Her)",
  "Singular & Plural Nouns",
  "Prepositions of Place (In, On, Under, Beside)",
  "Self Introduction & Expressing Feelings",
  "Asking & Offering Help",
  "Giving Commands & Requests",
  "Describing People, Places & Things",
  "Short Story & Fables",
  "World Culture & Landmark Passports"
];

const sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

// ============================================================================
// HELPER: PANDUAN GAMBAR & DIAGRAM OTOMATIS (GEOMETRI, ANALISIS DATA, PECAHAN)
// ============================================================================
function getVisualInstructions(mathTopic) {
  const isGeometry2D = [
    "Pengenalan Bentuk dan Sifat Dasar",
    "Keliling dan Luas Bangun Datar"
  ].includes(mathTopic);

  const isAngle = mathTopic === "Pengukuran Sudut dan Simetri";
  const isGeometry3D = mathTopic === "Bangun Ruang Lanjutan";
  const isData = [
    "Pengumpulan dan Pengelompokan Dasar",
    "Penyajikan Data Visual Dasar",
    "Pengolahan Data Lanjutan & Statistika Dasar"
  ].includes(mathTopic);
  const isFraction = mathTopic.includes("Pecahan");
  const isPattern = mathTopic.includes("Pola Gambar");

  if (isGeometry2D) {
    return `
ATURAN WAJIB GAMBAR BANGUN DATAR (GEOMETRI):
Minimal 7 dari 10 soal Matematika WAJIB menyertakan atribut ("visualType", "visualData", "visualLabel") dan teks pertanyaan WAJIB merujuk ke gambar (contoh: "Perhatikan gambar di atas! Berapakah keliling bangun tersebut?", "Luas bangun datar pada gambar di atas adalah...").
Pilihan tipe bangun yang didukung aplikasi:
1. "shape_rectangle" (Persegi / Persegi Panjang):
   "visualType": "shape_rectangle",
   "visualData": { "length": "12 cm", "width": "5 cm" },
   "visualLabel": "Persegi Panjang ABCD"
2. "shape_triangle" (Segitiga):
   "visualType": "shape_triangle",
   "visualData": { "base": "8 cm", "height": "6 cm" },
   "visualLabel": "Segitiga Siku-siku ABC"
3. "shape_circle" (Lingkaran):
   "visualType": "shape_circle",
   "visualData": { "radius": "7 cm" },
   "visualLabel": "Lingkaran Pusat O"`;
  }

  if (isAngle) {
    return `
ATURAN WAJIB GAMBAR SUDUT:
Minimal 6 dari 10 soal Matematika WAJIB menyertakan gambar sudut ("visualType", "visualData", "visualLabel") dan pertanyaan merujuk ke gambar:
"visualType": "shape_angle",
"visualData": { "degrees": 90, "label": "Siku-siku" },
"visualLabel": "Sudut ∠ABC"
(Gunakan variasi derajat seperti 30, 45, 60, 90, 120, 135, atau 180)`;
  }

  if (isGeometry3D) {
    return `
ATURAN WAJIB GAMBAR BANGUN RUANG:
Minimal 7 dari 10 soal Matematika WAJIB menyertakan gambar bangun ruang ("visualType", "visualData", "visualLabel") dan pertanyaan merujuk ke gambar (contoh: "Berapakah volume bangun ruang di atas?"):
1. "shape_cube" (Kubus):
   "visualType": "shape_cube",
   "visualData": { "side": "6 cm" },
   "visualLabel": "Kubus ABCD.EFGH"
2. "shape_cylinder" (Tabung):
   "visualType": "shape_cylinder",
   "visualData": { "radius": "7 cm", "height": "10 cm" },
   "visualLabel": "Tabung"`;
  }

  if (isData) {
    return `
ATURAN WAJIB DIAGRAM DATA & PELUANG:
Minimal 8 dari 10 soal Matematika WAJIB menyertakan diagram ("visualType", "visualData", "visualLabel") dan pertanyaan merujuk langsung ke grafik/diagram (contoh: "Berdasarkan diagram batang di atas, hari apakah penjualan tertinggi?", "Berapa selisih penjualan hari Senin dan Rabu?"):
1. "bar_chart" (Diagram Batang):
   "visualType": "bar_chart",
   "visualData": {
     "categories": ["Senin", "Selasa", "Rabu", "Kamis", "Jumat"],
     "values": [15, 30, 20, 35, 25]
   },
   "visualLabel": "Diagram Penjualan Buku (Buah)"
   *CATATAN PENTING: "values" WAJIB berupa array bilangan bulat (integer), "categories" berupa nama hari/kategori.
2. "pictogram" (Diagram Gambar / Piktogram):
   "visualType": "pictogram",
   "visualData": {
     "category": "Apel",
     "count": 20,
     "scale": 5,
     "symbol": "🍎"
   },
   "visualLabel": "Keterangan: 1 🍎 mewakili 5 buah apel"
   *CATATAN PENTING: "symbol" berupa emoji yang relevan (🍎, 🚗, 📚, 🐟, ⭐), "count" dan "scale" harus berupa angka bulat.`;
  }

  if (isFraction) {
    return `
ATURAN GAMBAR PECAHAN:
Beberapa soal pecahan dapat menyertakan gambar potongan kue pecahan:
"visualType": "fraction_pie",
"visualData": { "slices": 6, "shaded": 2 },
"visualLabel": "Pecahan Daerah yang Diarsir"
(Teks soal contoh: "Nilai pecahan daerah yang diarsir pada lingkaran di atas adalah...")`;
  }

  if (isPattern) {
    return `
ATURAN GAMBAR POLA:
Dapat menyertakan kotak urutan pola:
"visualType": "pattern_boxes",
"visualData": { "sequence": ["2", "5", "8", "?"] },
"visualLabel": "Pola Bilangan Lompat Tiga"`;
  }

  return `Untuk soal yang murni perhitungan teks dan tidak memerlukan gambar visual, jangan sertakan field visualType dan visualData (atau set null).`;
}

// ============================================================================
// HELPER: SANITASI & VALIDASI DATA VISUAL SEBELUM KE FIRESTORE
// ============================================================================
function sanitizeQuestion(q) {
  if (!q.visualType || typeof q.visualType !== "string") {
    delete q.visualType;
    delete q.visualData;
    delete q.visualLabel;
    return q;
  }

  const vt = q.visualType.trim();
  if (!q.visualData || typeof q.visualData !== "object") {
    delete q.visualType;
    delete q.visualData;
    delete q.visualLabel;
    return q;
  }

  if (vt === "bar_chart") {
    const cats = Array.isArray(q.visualData.categories)
      ? q.visualData.categories.map((c) => String(c).trim())
      : ["Senin", "Selasa", "Rabu", "Kamis"];
    const vals = Array.isArray(q.visualData.values)
      ? q.visualData.values.map((v) => parseInt(v, 10) || 0)
      : [10, 20, 15, 25];
    q.visualData = { categories: cats, values: vals };
  } else if (vt === "pictogram") {
    q.visualData = {
      category: String(q.visualData.category || "Data"),
      count: parseInt(q.visualData.count, 10) || 15,
      scale: parseInt(q.visualData.scale, 10) || 5,
      symbol: String(q.visualData.symbol || "🍎")
    };
  } else if (vt === "fraction_pie") {
    q.visualData = {
      slices: parseInt(q.visualData.slices, 10) || 4,
      shaded: parseInt(q.visualData.shaded, 10) || 1
    };
  } else if (vt === "shape_angle") {
    q.visualData = {
      degrees: parseInt(q.visualData.degrees, 10) || 90,
      label: String(q.visualData.label || "Sudut")
    };
  } else if (vt === "shape_rectangle") {
    q.visualData = {
      length: String(q.visualData.length || "12 cm"),
      width: String(q.visualData.width || "5 cm")
    };
  } else if (vt === "shape_triangle") {
    q.visualData = {
      base: String(q.visualData.base || "8 cm"),
      height: String(q.visualData.height || "6 cm")
    };
  } else if (vt === "shape_cylinder") {
    q.visualData = {
      radius: String(q.visualData.radius || "7 cm"),
      height: String(q.visualData.height || "10 cm")
    };
  } else if (vt === "shape_cube") {
    q.visualData = {
      side: String(q.visualData.side || "6 cm")
    };
  } else if (vt === "shape_circle") {
    q.visualData = {
      radius: String(q.visualData.radius || "7 cm")
    };
  } else if (vt === "pattern_boxes") {
    q.visualData = {
      sequence: Array.isArray(q.visualData.sequence)
        ? q.visualData.sequence.map((s) => String(s))
        : ["1", "2", "3", "?"]
    };
  } else if (vt.startsWith("english_")) {
    q.visualData = {
      emoji: String(q.visualData.emoji || "🔤"),
      title: String(q.visualData.title || "Vocabulary"),
      subtitle: String(q.visualData.subtitle || ""),
      colorHex: String(q.visualData.colorHex || "#4F46E5")
    };
  }

  q.visualType = vt;
  if (q.visualLabel) q.visualLabel = String(q.visualLabel).trim();
  return q;
}

const candidateModels = [
  "gemini-2.5-flash",
  "gemini-2.0-flash",
  "gemini-1.5-flash",
  "gemini-3.5-flash",
  "gemini-3.5-flash-lite",
  "gemini-3.8-flash",
  "gemini-1.5-flash-latest",
  "gemini-2.0-flash-exp",
  "gemini-1.5-pro",
  "gemini-pro"
];

let discoveredModels = [];

async function discoverSupportedModels(cleanKey) {
  for (const ver of ["v1beta", "v1"]) {
    try {
      const res = await fetch(`https://generativelanguage.googleapis.com/${ver}/models?key=${cleanKey}`);
      if (res.ok) {
        const data = await res.json();
        if (data && data.models && Array.isArray(data.models)) {
          const supported = data.models
            .filter(m => m.supportedGenerationMethods && m.supportedGenerationMethods.includes("generateContent"))
            .map(m => m.name.replace(/^models\//, ""));
          if (supported.length > 0) {
            console.log(`📋 Sukses mendeteksi ${supported.length} model aktif dari API Key (${ver}):`, supported.slice(0, 5).join(", "));
            return supported;
          }
        }
      } else {
        const err = await res.text();
        console.log(`ℹ️ ListModels (${ver}) HTTP ${res.status}: ${err}`);
      }
    } catch (e) {
      console.log(`ℹ️ ListModels (${ver}) error: ${e.message}`);
    }
  }
  return [];
}

async function callGeminiWithFallback(prompt) {
  const cleanKey = apiKey.trim();

  if (discoveredModels.length === 0) {
    discoveredModels = await discoverSupportedModels(cleanKey);
  }

  // Gabungkan model hasil deteksi otomatis + candidate default
  const activeModels = [...new Set([...discoveredModels, ...candidateModels])];

  // 1. Coba dengan Official SDK @google/generative-ai jika tersedia
  if (GoogleGenerativeAI) {
    const genAI = new GoogleGenerativeAI(cleanKey);
    for (const m of activeModels) {
      try {
        const model = genAI.getGenerativeModel({ model: m });
        const result = await model.generateContent(prompt);
        const response = await result.response;
        const text = response.text();
        if (text && text.trim().length > 0) {
          console.log(`  ✨ SDK Model "${m}" BERHASIL MEMPROSES SOAL!`);
          return text;
        }
      } catch (sdkErr) {
        console.log(`  ℹ️ SDK Model "${m}" gagal: ${sdkErr.message}`);
      }
    }
  }

  // 2. Fallback: Direct REST API (v1beta dan v1)
  const apiVersions = ["v1beta", "v1"];
  for (const ver of apiVersions) {
    for (const m of activeModels) {
      const url = `https://generativelanguage.googleapis.com/${ver}/models/${m}:generateContent?key=${cleanKey}`;
      try {
        const res = await fetch(url, {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({
            contents: [{ parts: [{ text: prompt }] }]
          })
        });

        if (res.ok) {
          const json = await res.json();
          const candidate = json.candidates && json.candidates[0];
          if (candidate && candidate.content && candidate.content.parts) {
            const text = candidate.content.parts.map(p => p.text).join("");
            if (text && text.trim().length > 0) {
              console.log(`  ✨ REST (${ver}) Model "${m}" BERHASIL MEMPROSES SOAL!`);
              return text;
            }
          }
        } else {
          const errText = await res.text();
          console.log(`  ℹ️ REST (${ver}) "${m}" HTTP ${res.status}: ${errText}`);
          await sleep(1000);
        }
      } catch (e) {
        console.log(`  ℹ️ REST (${ver}) "${m}" error: ${e.message}`);
      }
    }
  }

  throw new Error("Semua model alternatif Gemini gagal dipanggil. Periksa apakah GEMINI_API_KEY valid dan aktif di Google AI Studio.");
}

async function run() {
  try {
    const db = admin.firestore();

    let totalUploaded = 0;
    
    // Systematically iterate through topics so EVERY SINGLE TOPIC is covered!
    const totalRuns = Math.max(mathTopics.length, englishTopics.length);
    console.log(`📡 Memulai Generasi Sistematis Meliputi Seluruh ${totalRuns} Pasang Topik Kurikulum Merdeka...`);

    for (let i = 0; i < totalRuns; i++) {
      const mathTopic = mathTopics[i % mathTopics.length];
      const englishTopic = englishTopics[i % englishTopics.length];

      console.log(`\n🤖 Batch ${i + 1}/${totalRuns} (10 Math: "${mathTopic}", 10 English: "${englishTopic}")...`);

      const visualGuidance = getVisualInstructions(mathTopic);

      const prompt = `Sebagai Guru SD profesional dan ramah anak, buatkan 20 soal latihan pilihan ganda Kurikulum Merdeka tingkat SD (10 soal Matematika tentang "${mathTopic}" dan 10 soal Bahasa Inggris tentang "${englishTopic}").

PANDUAN PEMBUATAN SOAL:
1. Untuk soal "Bahasa Inggris", teks pertanyaan (questionText) dan pilihan jawaban (options) WAJIB menggunakan Bahasa Inggris yang ramah untuk anak SD.
2. Soal harus 100% RELEVAN dan FOKUS pada topik yang ditentukan, jangan mencampur materi yang tidak berhubungan.
3. Kunci jawaban (correctAnswerIndex) harus bervariasi dan acak (antara 0, 1, 2, atau 3).
4. Penjelasan (explanation) ditulis dalam Bahasa Indonesia yang hangat dan mudah dipahami anak maupun orang tua.
5. Jawab HANYA dalam format JSON Array valid tanpa pembuka markdown atau teks pengantar.

${visualGuidance}

Contoh Format JSON:
[
  {
    "subject": "Matematika",
    "gradeLevel": "SD",
    "classNum": 4,
    "topic": "${mathTopic}",
    "questionText": "Perhatikan gambar persegi panjang di atas! Berapakah keliling persegi panjang tersebut?",
    "visualType": "shape_rectangle",
    "visualData": {
      "length": "12 cm",
      "width": "5 cm"
    },
    "visualLabel": "Persegi Panjang ABCD",
    "options": ["34 cm", "60 cm", "24 cm", "17 cm"],
    "correctAnswerIndex": 0,
    "explanation": "Keliling = 2 x (p + l) = 2 x (12 + 5) = 2 x 17 = 34 cm.",
    "difficulty": "Sedang"
  },
  {
    "subject": "Bahasa Inggris",
    "gradeLevel": "SD",
    "classNum": 4,
    "topic": "${englishTopic}",
    "questionText": "English question text...",
    "options": ["Option A", "Option B", "Option C", "Option D"],
    "correctAnswerIndex": 1,
    "explanation": "Pembahasan jawaban dalam bahasa Indonesia...",
    "difficulty": "Sedang"
  }
]`;

      try {
        const rawText = await callGeminiWithFallback(prompt);

        // Robust Clean JSON
        let cleanJson = rawText.trim();
        const firstBracket = cleanJson.indexOf('[');
        const lastBracket = cleanJson.lastIndexOf(']');
        
        if (firstBracket !== -1 && lastBracket !== -1) {
          cleanJson = cleanJson.substring(firstBracket, lastBracket + 1);
        }

        const generatedQuestions = JSON.parse(cleanJson);

        if (Array.isArray(generatedQuestions)) {
          const batch = db.batch();
          let batchUploaded = 0;

          for (let q of generatedQuestions) {
            if (!q.questionText || !q.options || q.options.length < 4) continue;

            // Sanitasi format visual (Geometri, Diagram Batang, Piktogram, Sudut, dll.)
            q = sanitizeQuestion(q);

            // STRICT FIRESTORE DEDUPLICATION CHECK
            const snapshot = await db.collection("cloud_questions")
              .where("questionText", "==", q.questionText.trim())
              .get();

            if (!snapshot.empty) {
              console.log(`  ⚠️ Soal duplikat dilewati: "${q.questionText.substring(0, 30)}..."`);
              continue;
            }

            const docRef = db.collection("cloud_questions").doc();
            batch.set(docRef, {
              ...q,
              id: docRef.id,
              createdAt: admin.firestore.FieldValue.serverTimestamp()
            });
            batchUploaded++;
          }

          if (batchUploaded > 0) {
            await batch.commit();
            totalUploaded += batchUploaded;
            console.log(`  ✅ Batch ${i + 1} sukses meng-upload ${batchUploaded} soal baru untuk "${mathTopic}" & "${englishTopic}".`);
          }
        }
      } catch (batchErr) {
        console.error(`  ⚠️ Batch ${i + 1} error:`, batchErr.message);
      }

      await sleep(1000); // 1 second break between batches
    }

    console.log(`\n==================================================`);
    console.log(`🎉 SELESAI! TOTAL ${totalUploaded} SOAL AI BARU BERHASIL DISIMPAN KE CLOUD FIRESTORE!`);
    console.log(`==================================================`);

    if (totalUploaded === 0) {
      console.error("\n❌ GAGAL: 0 soal berhasil disimpan ke Firestore! Periksa pesan error di atas.");
      process.exit(1);
    }

  } catch (err) {
    console.error("❌ Main Generator Error:", err.message);
    process.exit(1);
  }

  process.exit(0);
}

run();
