
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';

class ContactTile extends StatefulWidget {
  final Contact contact;
  const ContactTile({super.key, required this.contact});

  @override
  State<ContactTile> createState() => _ContactTileState();
}

class _ContactTileState extends State<ContactTile> {
  @override
  Widget build(BuildContext context) {
    return Container(decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300,width: 1),color: Colors.white),
      height: 80,
      child: Row(
        children: [
          Container(decoration: BoxDecoration(color: Colors.grey.shade100),height: 80,width: 80,child: widget.contact.thumbnail==null?Center(child: Text(widget.contact.displayName[0],style: TextStyle(fontSize: 36),)):Image.memory(this.widget.contact.thumbnail!),),
          Expanded(child: Container(padding: EdgeInsets.only(left: 20),height: 80,child: Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment:MainAxisAlignment.spaceEvenly,children: [Text(widget.contact.displayName),Container(height: 40,child: Row(children: [Image.asset("assets/group.png"),SizedBox(width: 18,),Text(widget.contact.groups.join(", "))],),) ],),))

        ],
      ),
    );
  }
}
