import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_app/data/userData.dart';
import 'package:food_app/localization.dart';
import 'package:food_app/models/user.dart';
import 'package:food_app/services/auth.dart';
import 'package:food_app/services/database.dart';
import 'package:food_app/widgets/food_time_card.dart';
import 'package:food_app/widgets/tags_bar.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static final String id = 'home_page';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User user = User();

  // Services
  PageController _timeRecipesController;

  @override
  void initState() {
    super.initState();
    _timeRecipesController = PageController(initialPage: _getPageBasedOnTime());
  }

  _showError() {}

  _getPageBasedOnTime() {
    int currentHour = DateTime.now().hour;
    int page;

    if (0 <= currentHour && currentHour <= 9) {
      // Breakfast
      page = 0;
    } else if (10 <= currentHour && currentHour <= 13) {
      // Lunch
      page = 1;
    } else if (14 <= currentHour && currentHour <= 16) {
      //  Snack
      page = 2;
    } else if (17 <= currentHour && currentHour <= 24) {
      // Evening
      page = 3;
    }

    return page;
  }

  Widget _buildBody(User user) {
    return ListView(
      children: <Widget>[
        // "Good afternoon" text
        Container(
          height: 100,
          margin: EdgeInsets.symmetric(vertical: 15),
          padding: EdgeInsets.symmetric(horizontal: 68),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image(
                image: AssetImage('assets/images/good_afternoon.png'),
                height: 50,
              ),
              Container(
                  height: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Good Afternoon!',
                        style: TextStyle(
                          color: Color(0xFF282828),
                          fontWeight: FontWeight.w600,
                          fontSize: 22,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'What would you like to have?',
                        style: TextStyle(
                          color: Color(0xFF565656),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),

        // Recipes, based on time
        Container(
          width: double.infinity,
          height: 150,
          margin: EdgeInsets.symmetric(vertical: 10),
          child: PageView(
            controller: _timeRecipesController,
            children: <Widget>[
              // Breakfast
              FoodBasedOnTimeCard(
                bg: LinearGradient(
                  colors: [Color(0xFFFE95B1), Color(0xFFFFA881)],
                ),
                title: AppLocalizations.of(context)
                    .translate('home_timeRec_first_title'),
                subtitle: AppLocalizations.of(context)
                    .translate('home_timeRec_first_subtitle'),
                image: AssetImage('assets/images/breakfast.png'),
                keyword: 'breakfast',
              ),

              // Lunch
              FoodBasedOnTimeCard(
                bg: LinearGradient(
                  colors: [Color(0xFF81C3F6), Color(0xFFA397FE)],
                ),
                title: AppLocalizations.of(context)
                    .translate('home_timeRec_second_title'),
                subtitle: AppLocalizations.of(context)
                    .translate('home_timeRec_second_subtitle'),
                image: AssetImage('assets/images/lunch.png'),
                keyword: 'lunch',
              ),

              // Snacks
              FoodBasedOnTimeCard(
                bg: LinearGradient(
                  colors: [Color(0xFFFF946E), Color(0xFFFC7E72)],
                ),
                title: AppLocalizations.of(context)
                    .translate('home_timeRec_third_title'),
                subtitle: AppLocalizations.of(context)
                    .translate('home_timeRec_third_subtitle'),
                image: AssetImage('assets/images/sneaks.png'),
                keyword: 'snacks',
              ),

              // Dinner
              FoodBasedOnTimeCard(
                bg: LinearGradient(
                  colors: [Color(0xFF6E6FFD), Color(0xFF9767DC)],
                ),
                title: AppLocalizations.of(context)
                    .translate('home_timeRec_fourth_title'),
                subtitle: AppLocalizations.of(context)
                    .translate('home_timeRec_fourth_subtitle'),
                image: AssetImage('assets/images/dinner.png'),
                keyword: 'dinner',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar(User user) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      centerTitle: true,
      title: Text(
        AppLocalizations.of(context).translate('home_title'),
        style: TextStyle(
          color: Color(0xFF282828),
        ),
      ),
      leading: Container(
        margin: EdgeInsets.all(9),
        child: CircleAvatar(
          backgroundColor: Colors.black12,
          backgroundImage: user.profileImageUrl == ''
              ? AssetImage('assets/images/placeholder.png')
              : CachedNetworkImageProvider(user.profileImageUrl),
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.notifications_none),
          onPressed: () => print('go to notifications page'),
          color: Color(0xFF565656),
        ),
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () => print('go to search page'),
          color: Color(0xFF565656),
        ),
      ],
      bottom: TagsBar(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DatabaseServices.getUserById(
          Provider.of<UserData>(context).currentUserId),
      builder: (BuildContext context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          default:
            if (snapshot.hasError)
              return _showError();
            else {
              return Scaffold(
                appBar: _buildAppBar(snapshot.data),
                body: _buildBody(snapshot.data),
              );
            }
        }
      },
    );
  }
}
