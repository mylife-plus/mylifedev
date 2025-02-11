import 'package:flutter/material.dart';
import 'package:mapbox_maps_example/repository/memoryRepo.dart';

class MemoryFeedScreen extends StatefulWidget {
  const MemoryFeedScreen({Key? key}) : super(key: key);

  @override
  MemoryFeedScreenState createState() => MemoryFeedScreenState();
}

class MemoryFeedScreenState extends State<MemoryFeedScreen> with AutomaticKeepAliveClientMixin{

  @override
  Widget build(BuildContext context) {

    MemoryRepository memoryRepository = MemoryRepository.instance;

    super.build(context);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: ListView(
        physics: const BouncingScrollPhysics(),

        children: [
          Container(
            color: Colors.white,
            margin: EdgeInsets.only(top: 20),
            child: FutureBuilder(
              future: memoryRepository.getAllMemoriesWithMedia(),
              builder: (BuildContext context, snapshot) {
                if (snapshot.hasData){
                return Column(
                  children: [

                    ...snapshot.data!.map((e)=>Text(e.memory.xCoordinate.toString()+"  "+e.memory.yCoordinate.toString()))


                  ],
                );}
                else if (snapshot.hasError){
                  return Text(snapshot.error.toString());
                }
                return CircularProgressIndicator();
              }
            ),
          ),
        ],
      ),

    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
