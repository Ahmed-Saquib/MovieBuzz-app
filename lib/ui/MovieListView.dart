import 'package:HelloWorld/model/movie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MovieListView extends StatelessWidget {
  List<Movie> movieList = Movie.getMovies();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movies'),
        backgroundColor: Colors.teal,
      ),
      backgroundColor: Colors.white,
      body: ListView.builder(
          itemCount: movieList.length,
          itemBuilder: (BuildContext context, int index) {
            return Stack(
                children:<Widget>[

                Positioned(child: movieCard(movieList[index], context)),
                Positioned(
                    top: 10,
                    left: 5,
                    child: movieImage(movieList[index].images[0]))
                ]);
            return Card(
              elevation: 5,
              color: Colors.white,
              child: ListTile(
                leading: CircleAvatar(
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(movieList[index].images[0]),
                            fit: BoxFit.cover),

                        //color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(14)),
                  ),
                ),
                trailing: Text('more info'),
                title: Text('${movieList[index].title}'),
                subtitle: Text('${movieList[index].genre}'),
                //onTap:() => debugPrint('Movie name ${movies[index]}'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InsideMovie(
                                movieName: movieList[index].title,
                              )));
                },
              ),
            );
          }),
    );
  }

  Widget movieCard(Movie movie , BuildContext context ){
    return InkWell(
      child: Container(
        margin: EdgeInsets.only(left: 60),
        width: MediaQuery.of(context).size.width,
        height: 120.0,
        child: Card(
          color: Colors.teal.shade200,
          child: Padding(
            padding: const EdgeInsets.only(top:8.0,bottom: 8.0,left:40.0,right: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children:<Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
               children: <Widget>[
                 Flexible(
                   child: Text(movie.title, style: TextStyle(
                     fontWeight: FontWeight.bold,
                     fontSize: 18.0,
                   ),),
                 ),
                 Text('Rating : ${movie.imdbRating} / 10')
            ],

            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children:<Widget> [
                Text('Released : ${movie.released}'),
                Text('Duration : ${movie.runtime}'),

              ],
            )
              ],)
            ),
          ),
        ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => InsideMovie(
                  movieName: movie.title,movie: movie,
                )));
      },
      );

  }
  Widget movieImage(String imageURL){
    return Container(
      width: 100
      ,height: 100,
      decoration: BoxDecoration(

        shape: BoxShape.circle,
        image: DecorationImage(
          image: NetworkImage(imageURL ?? ''),
          fit: BoxFit.cover
        )
      ),

    ); 
  }
}

// new page
class InsideMovie extends StatelessWidget {
  final String movieName;
  final Movie movie;


  const InsideMovie({Key key, this.movieName, this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$movieName'),
        backgroundColor: Colors.teal,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        children: <Widget>[
          MovieDetailsThumbnail(thumbnail: movie.images[0],),
          MovieDetailsHeaderWithPoster(Movie: movie),
          HorizontalLine(),
          MovidDetailsCast(movie: movie),
          HorizontalLine(),
          MovieExtraPosters(poster: movie.images,)
        ],
      ),
      // body: Center(
      //   child: Container(
      //     child: RaisedButton(
      //         child: Text('Go back'),
      //         onPressed: () {
      //           Navigator.pop(context);
      //         }),
      //   ),
      // ),
    );
  }

}
class MovieDetailsThumbnail extends StatelessWidget {
  final String thumbnail;

  const MovieDetailsThumbnail({Key key, this.thumbnail}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: 160,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(thumbnail),
                      fit: BoxFit.cover
                  )
              ),
            ),
            Icon(Icons.play_circle_outline,size: 100,color: Colors.white,)
          ],
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Color(0x00f5f5f5),Color(0xfff5f5f5)],
            begin: Alignment.topCenter,
              end: Alignment.bottomCenter
            ),

          ),
          height: 50,
        )
      ],
    );
  }
}
class MovieDetailsHeaderWithPoster extends StatelessWidget {
  // ignore: non_constant_identifier_names
  final Movie;

  const MovieDetailsHeaderWithPoster({Key key, this.Movie}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children:<Widget> [
          MoviePoster(poster: Movie.images[0].toString()),
          SizedBox(  width: 16,),
          Expanded(child: MovieDetailsHeader(movie :Movie)),

        ],
      ),
    );
  }
}



class MoviePoster extends StatelessWidget {
  final String poster;

  const MoviePoster({Key key, this.poster}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var borderRadius = BorderRadius.all(Radius.circular(10));
    return Card(
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Container(
          width: MediaQuery.of(context).size.width/4,
          height: 160,
          decoration: BoxDecoration(
            image: DecorationImage(image: NetworkImage(poster),
            fit: BoxFit.cover),

          ),
        ),
      )
    );
  }
}
class MovieDetailsHeader extends StatelessWidget {
  final Movie movie;

  const MovieDetailsHeader({Key key, this.movie}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:<Widget> [
        Text('${movie.year}, ${movie.genre}'.toUpperCase(),
        style: TextStyle(
          fontWeight: FontWeight.w400,
          color: Colors.cyan
        ),),
        Text(movie.title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 32
        ),),
        Text.rich(TextSpan(style: TextStyle(
          fontSize: 13, fontWeight: FontWeight.w300
        ),
          children: <TextSpan>[
            TextSpan(
              text: movie.plot
            ),
            TextSpan(
              text: 'More...',
              style: TextStyle(
                color: Colors.cyan
              )
            )
          ]
        ))
      ],
    );
  }
}
class MovidDetailsCast extends StatelessWidget {
  final Movie movie;

  const MovidDetailsCast({Key key, this.movie}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: <Widget>[
          MovieField(field :  'Cast', value : movie.actors),
          MovieField(field :  'Directors', value : movie.director),
          MovieField(field :  'Awards', value : movie.awards),


        ],

      ),
    );
  }
}
class MovieField extends StatelessWidget {
  final String field;
  final String value;

  const MovieField({Key key, this.field, this.value}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('$field : ',style: TextStyle(
          color: Colors.black38,
          fontSize: 12,
          fontWeight: FontWeight.w300
        ),),
        Expanded(
          child: Text( value,style: TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontWeight:  FontWeight.w300
          ),),
        )
      ],
    );
  }
}
class HorizontalLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: Container(
        height: 0.5,
        color: Colors.grey,
      ),
    );
  }
}
class MovieExtraPosters extends StatelessWidget {
  final List<String>poster;

  const MovieExtraPosters({Key key, this.poster}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0, left: 16.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Movie scenes'.toUpperCase(),
            style: TextStyle(
              fontSize: 14,
              color: Colors.black26
            ),),
            Padding(
              padding: const EdgeInsets.only(top:8.0),
              child: Container(
                height: 150,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                    itemBuilder: (context,index) => ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: MediaQuery.of(context).size.width/4,
                        height: 150,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(poster[index]),
                            fit: BoxFit.cover,
                          )
                        ),
                      ),
                    ),
                    separatorBuilder: (context,index) => SizedBox(width: 8,),
                    itemCount: poster.length),
              ),
            )
          ],

      ),
    );
  }
}


