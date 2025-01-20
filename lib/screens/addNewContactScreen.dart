
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
class AddNewContactScreen extends ConsumerStatefulWidget {
  const AddNewContactScreen({super.key});

  @override
  ConsumerState createState() => _AddNewContactScreenState();
}

class _AddNewContactScreenState extends ConsumerState<AddNewContactScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? selectedImage;
  Uint8List? selectedImageBytes;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: Container(
          color: Colors.white,
          height: double.infinity,
          width: double.infinity,
          child: Column(
            children: [
              Material(
                elevation: 1,
                color: Colors.grey.shade100,
                child: SizedBox.fromSize(size: Size.fromHeight(80),
                child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(onPressed: (){Navigator.of(context).pop();}, icon: Icon(Icons.cancel_outlined,size: 36,)),

                      Text('New Contact',style: TextStyle(fontSize: 26),),

                      IconButton(onPressed: (){}, icon: Icon(Icons.check,size: 36,)),
                    ],
                  ),),
              ),
              SizedBox(height: 24,),
              Center(child: GestureDetector(
              onTap: () async
              {
              selectedImage = await _imagePicker.pickImage(source: ImageSource.gallery);
              final bytes = await selectedImage?.readAsBytes();
              setState(() {

                selectedImageBytes = bytes ;

              });
              },
                  child: Stack(
                    children: [
                      Container(margin: EdgeInsets.all(6),color: Colors.grey.shade100,height: 120,width: 120,child: selectedImage==null?Icon(Icons.image,size: 36,):Image.memory(selectedImageBytes!, fit: BoxFit.fill,),),
                      Positioned(bottom: 0,right: 0,child: Icon(Icons.add_photo_alternate_outlined, size: 26,color: Colors.black,)),

                    ],
                  )),),
              SizedBox(height: 30,),
              SizedBox.fromSize(size:Size.fromHeight(40),
              child:Row(
                children: [
                  Flexible(child: Container(child: TextField(),)),
                  Flexible(child: Container(child: TextField(),)),
                ],
              ),)
            ],
          ),
        ),
      ),
    );
  }

}
