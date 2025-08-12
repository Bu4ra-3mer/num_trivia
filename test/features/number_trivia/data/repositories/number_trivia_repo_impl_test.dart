import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:num_trivia/core/errors/exceptions.dart';
import 'package:num_trivia/core/network/network_into.dart';
import 'package:num_trivia/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:num_trivia/features/number_trivia/data/repositories/umber_trivia_repo_impl.dart';

class MockRemoteDataSource extends Mock 
implements NumberTriviaLocalDataSource{}

class MockLocalDataSource extends Mock 
implements NumberTriviaLocalDataSource{}

class class MockNetworkInfo extends Mock implements NetworkInfo {}

void main(){
  NumberTriviaRepoImpl repository;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp((){
 mockRemoteDataSource=MockRemoteDataSource();
 mockLocalDataSource=MockLocalDataSource();
 mockNetworkInfo=MockNetworkInfo();
  repository=NumberTriviaRepoImpl(
    RemoteDataSource:mockRemoteDataSource,
    LocalDataSource:mockLocalDataSource,
    NetworkInfo:mockNetworkInfo,

  );
 

  });
  void runTestOnline(Function body){
   group('device is online', (){
      setUp((){
          when(mockNetworkInfo.isConnected).thenAnswer((_)=>true);
      });
      body();
  });
  }
  void runTestOnline(Function body){
   group('device is offline', (){
      setUp((){
          when(mockNetworkInfo.isConnected).thenAnswer((_)=>false);
      });
      body();
  });}
  group('getRandomumberTrivia',(){
    final tNumber=1;
    final tNumberTriviaModel(number:tNumber, text:'test trivia');
    final NumberTrivia tNumberTrivia=tNumberTriviaModel;
    test('should check if the device is online', ()async {
      //arrange
       when(mockNetworkInfo.isConnected).thenAnswer((_)=>true);
       //act
      final result= repository.getConcreteNumberTrivia(tNumber);
       //assert
       verify(mockNetworkInfo.isConnected);

      
    });
    runTestOnline( (){
           test('should return remote data when the call to remote data source is succes',
       () async{
      //arrange  
        when(mockRemoteDataSource.getConcreteNumberTriviva(any))
        .thenAnswer((_)async=>tNumberTrivia);
        //act
    final result=await repository.getConcreteNumberTrivia(tnumber);
        //assert
        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        expect(result,equals(Right(tNumberTrivia)));
      });
    });
      test('should cache the data locally when the call to remote data source is succes',
       () async{
      //arrange  
        when(mockRemoteDataSource.getConcreteNumberTriviva(any))
        .thenAnswer((_)async=>tNumberTrivia);
        //act
        await repository.getConcreteNumberTrivia(tnumber);
        //assert
        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
    
      });
      test('should return server failure when the call to remote data source is unsuccessful',
       () async{
      //arrange  
        when(mockRemoteDataSource.getConcreteNumberTriviva(any))
        .thenThrow(ServerException());
        //act
    final result=await repository.getConcreteNumberTrivia(tnumber);
        //assert
        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verifyZeroInteractions(mockLocalDataSource);
        expect(result,equals(Left(ServerFailure())));
      });
    });
   
    runTestOffline( (){
      
    });
    test('should return last locally cached data when the ached data is present', ()async {
      //arrange
      when(mockLocalDataSource.getLastNumberTrivia())
      .thenAnswer((_)async=>tNumberTriviaModel);
      //act
      final result= repository.getConcreteNumberTrivia(tNumber);
      //assert
      verifyZeroInteractions(mockRemoteDataSource);
      verify(mockLocalDataSource.getLastNumberTrivia());
      expect(result, equals(Right(tNumberTrivia)));
    });
    test('should return cache failure when there is no ached data present', ()async {
      //arrange
      when(mockLocalDataSource.getLastNumberTrivia())
      .thenThrow(CacheException());
      //act
      final result= repository.getConcreteNumberTrivia(tNumber);
      //assert
      verifyZeroInteractions(mockRemoteDataSource);
      verify(mockLocalDataSource.getLastNumberTrivia());
      expect(result, equals(Left(CacheFailure)));
    });
  }