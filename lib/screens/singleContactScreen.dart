import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:iconsax/iconsax.dart';
import '../utils.dart';


class SingleContactScreen extends StatefulWidget {
  final Contact contact;

  const SingleContactScreen({super.key, required this.contact});

  @override
  State<SingleContactScreen> createState() => _SingleContactScreenState();
}

class _SingleContactScreenState extends State<SingleContactScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Material(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Material(
              elevation: 1,
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 8),
                height: 60,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Iconsax.arrow_left_3,
                          color: Colors.black,
                          size: 38,
                        )),
                    Text(
                      widget.contact.displayName.replaceRange(
                          0, 1, widget.contact.displayName[0].toUpperCase()),
                      style: TextStyle(fontSize: 26),
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Iconsax.edit,
                          size: 38,
                        )),
                  ],
                ),
              ),
            ),
            Material(
                elevation: 1,
                child: Container(
                  margin: EdgeInsets.only(top: 32),
                  child: Center(
                    child: widget.contact.thumbnail != null
                        ? Image.memory(
                            widget.contact.thumbnail!,
                          )
                        : Text(widget.contact.displayName[0].toUpperCase()),
                  ),
                )),
            Material(
                elevation: 1,
                child: Container(
                  padding: EdgeInsets.only(left: 8),
                  height: 64,
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.grey, width: 1)),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 22,
                        child: Row(
                          children: [
                            Text("Display Name",
                                style: TextStyle(color: Colors.grey.shade800)),
                          ],
                        ),
                      ),
                      Container(
                        height: 34,
                        child: Row(
                          children: [
                            Icon(Iconsax.profile_circle),
                            SizedBox(width: 16),
                            Text(
                              capitalize(widget.contact.displayName),
                              style: TextStyle(fontSize: 24),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
            Material(
                elevation: 1,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          bottom: BorderSide(color: Colors.grey, width: 1))),
                  padding: EdgeInsets.only(left: 8),
                  height: 64,
                  child: Column(
                    children: [
                      Container(
                        height: 22,
                        child: Row(
                          children: [
                            Text("Phone Number",
                                style: TextStyle(color: Colors.grey.shade800)),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            Icon(Iconsax.mobile),
                            SizedBox(
                              width: 12,
                            ),
                            Text(
                              widget.contact.phones[0].number ?? "",style: TextStyle(fontSize: 26)
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
            Material(
                elevation: 1,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          bottom: BorderSide(color: Colors.grey, width: 1))),
                  padding: EdgeInsets.only(left: 8),
                  height: 64,
                  child: Column(
                    children: [
                      Container(
                        height: 22,
                        child: Row(
                          children: [
                            Text("Address",
                                style: TextStyle(color: Colors.grey.shade800)),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            Icon(Iconsax.location),
                            SizedBox(
                              width: 12,
                            ),
                            Text(
                              widget.contact.addresses.isEmpty?"": widget.contact.addresses[0].address,style: TextStyle(fontSize: 26)
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )),

            Material(
                elevation: 1,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          bottom: BorderSide(color: Colors.grey, width: 1))),
                  padding: EdgeInsets.only(left: 8),
                  height: 64,
                  child: Column(
                    children: [
                      Container(
                        height: 22,
                        child: Row(
                          children: [
                            Text("Email",
                                style: TextStyle(color: Colors.grey.shade800)),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            Icon(Iconsax.direct_inbox),
                            SizedBox(
                              width: 12,
                            ),
                            Text(
                              widget.contact.emails.isEmpty?"":widget.contact.emails[0].address,style: TextStyle(fontSize: 26)
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
            Material(
                elevation: 1,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          bottom: BorderSide(color: Colors.grey, width: 1))),
                  padding: EdgeInsets.only(left: 8),
                  height: 64,
                  child: Column(
                    children: [
                      Container(
                        height: 22,
                        child: Row(
                          children: [
                            Text("Websites",
                                style: TextStyle(color: Colors.grey.shade800)),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            Icon(Iconsax.global),
                            SizedBox(
                              width: 12,
                            ),
                            Text(
                              widget.contact.websites.map((e)=>e.url).join(", "),style: TextStyle(fontSize: 26)
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
            GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => Dialog(
                          backgroundColor: Colors.white,
                          child: Container(
                            height: 200,
                            width: 200,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [Text("data")],
                            ),
                          ),
                        ));
              },
              child: Material(
                  elevation: 1,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                            bottom: BorderSide(color: Colors.grey, width: 1))),
                    padding: EdgeInsets.only(left: 8),
                    height: 64,
                    child: Column(
                      children: [
                        Container(
                          height: 22,
                          child: Row(
                            children: [
                              Text("Groups Name",
                                  style:
                                      TextStyle(color: Colors.grey.shade800)),
                            ],
                          ),
                        ),
                        Container(
                          child: Row(
                            children: [
                              Image.asset(
                                "assets/group.png",
                                width: 32,
                                height: 32,
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Text(
                                widget.contact.groups.map((e)=>e.name).join(", "),style: TextStyle(fontSize: 26)
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
            Center(
              child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Iconsax.add_square,
                    size: 38,
                  )),
            )
          ],
        ),
      ),
    ));
  }
}
