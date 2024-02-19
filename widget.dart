void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Text Recognition App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TextRecognitionScreen(),
    );
  }
}

class TextRecognitionScreen extends StatefulWidget {
  @override
  _TextRecognitionScreenState createState() => _TextRecognitionScreenState();
}

class _TextRecognitionScreenState extends State<TextRecognitionScreen> {
  String _recognizedText = '';

  Future<void> _performTextRecognition() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage == null) return;

    final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(File(pickedImage.path));
    final TextRecognizer textRecognizer = FirebaseVision.instance.textRecognizer();
    final VisionText visionText = await textRecognizer.processImage(visionImage);

    String recognizedText = '';

    for (TextBlock block in visionText.blocks) {
      for (TextLine line in block.lines) {
        recognizedText += line.text + '\n';
      }
    }

    setState(() {
      _recognizedText = recognizedText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Text Recognition App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _performTextRecognition,
              child: Text('Select Image for Text Recognition'),
            ),
            SizedBox(height: 20),
            SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Text(
                _recognizedText,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
