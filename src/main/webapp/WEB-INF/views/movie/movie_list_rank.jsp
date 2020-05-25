<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>영화 그 이상의 감동. CGW</title>

	<link rel="stylesheet" href="${ pageContext.request.contextPath }/resources/css/movie_rank.css">
	
	<script type="text/javascript" src="${ pageContext.request.contextPath }/resources/js/httpRequest.js"></script>
	<script type="text/javascript">
		var wholeCount = 0;
		var okSignal = 0;
		
		window.onload=function(){
			load_list();
		};
		
		//포스터 잘라쓰기
		function cutPoster(posters) {
			  if (posters.indexOf("|") !== -1) {
			    posters = posters.substring(0, posters.indexOf("|"));
			  }

			  if (posters === "") {
			    posters = "${ pageContext.request.contextPath }/resources/img/nullImg.png";
			  }
			  return posters;
		}
		
		//loading문구 지우기
		function loading_del(){

		    var loadingText = document.getElementById("loadingText");
		    loadingText.removeChild( loadingText.children[0] );
		    
		}
		//목록을 가져오는 함수
		function load_list(){
			//192.168.1.101:9090/vs/list.do
			var url ='http://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json';
			var param = 'key=a7c6bfb2e16d4d1ae14730f90bc6726a&targetDt=20200521';
			sendRequest( url, param, resultFn, "GET" );
			
		}
		
		function resultFn(){
			
			if( xhr.readyState == 4 && xhr.status == 200 ){
				
				var data = xhr.responseText;
				var json = eval("["+data+"]");
				
				var movie_list =document.getElementById("movie_list");
				for(var i=0 ; i<json[0].boxOfficeResult.dailyBoxOfficeList.length ; i++){
					
					var movie_container = "movie_list_"+i;//영화 정보 담는 컨테이너
					document.getElementById("movie_movieCd_"+i).value=json[0].boxOfficeResult.dailyBoxOfficeList[i].movieCd;//영화 코드(영진위)
					document.getElementById("movie_movieNm_"+i).value=json[0].boxOfficeResult.dailyBoxOfficeList[i].movieNm;//영화 제목에서 자르기(영진위)
					
			    	document.getElementById("movie_rank_movieNm_"+i).innerHTML=json[0].boxOfficeResult.dailyBoxOfficeList[i].movieNm;;//영화 제목
			    	/* document.getElementById("movie_list_poster_"+i+"_img").src=moviePoster;//포스터 */
			    	document.getElementById("movie_rank_rank_"+i).innerHTML=json[0].boxOfficeResult.dailyBoxOfficeList[i].rank+" 위";//순위
			    	document.getElementById("movie_rank_salesShare_"+i).innerHTML=json[0].boxOfficeResult.dailyBoxOfficeList[i].salesShare+" %";//예매율
			    	document.getElementById("movie_rank_audiAcc_"+i).innerHTML="누적관객수 : "+json[0].boxOfficeResult.dailyBoxOfficeList[i].audiAcc+"명";//누적관객수
			    	document.getElementById("movie_rank_openDt_"+i).innerHTML=json[0].boxOfficeResult.dailyBoxOfficeList[i].openDt+"개봉";//개봉일
			    	
				}
				
				var movieCd = document.getElementById("movie_movieCd_"+0).value;
				var movieNm = document.getElementById("movie_movieNm_"+0).value;
				load_poster0(movieCd, movieNm);
				
				var movieCd = document.getElementById("movie_movieCd_"+1).value;
				var movieNm = document.getElementById("movie_movieNm_"+1).value;
				load_poster1(movieCd, movieNm);

				loading_del();
				
			}
			
		}
		
		//-------------------------------------------------------------------
				
		function load_poster0(movieCd, movieNm){
			
			var createDts = movieCd.substring(0, 4);
			var url2 ='http://api.koreafilm.or.kr/openapi-data2/wisenut/search_api/search_json2.jsp';
			var param2 = 'collection=kmdb_new2&detail=Y&ServiceKey=U8ECM752YKB763PI62AV&createDts='+createDts+'&title='+movieNm;
			sendRequest( url2, param2, resultFn0, "GET" );
			
		}
		function resultFn0(){				
			if( xhr.readyState == 4 && xhr.status == 200 ){
				var data = xhr.responseText;
				var json = eval("["+data+"]");
				
				var movie_container = "movie_list_"+0;//영화 정보 담는 컨테이너

		    	var moviePoster = cutPoster(json[0].Data[0].Result[0].posters);//json형식으로 넘어온 값이 여러개의 포스터일 경우 하나의 포스터를 가져옴
		    	document.getElementById("movie_rank_poster_"+0+"_img").src=moviePoster;//포스터
		    	wholeCount++;
			}
		}
		/* function load_poster1(movieCd, movieNm){
			
			var createDts = movieCd.substring(0, 4);
			var url2 ='http://api.koreafilm.or.kr/openapi-data2/wisenut/search_api/search_json2.jsp';
			var param2 = 'collection=kmdb_new2&detail=Y&ServiceKey=U8ECM752YKB763PI62AV&createDts='+createDts+'&title='+movieNm;
			sendRequest( url2, param2, resultFn1, "GET" );
			
		}
		function resultFn1(){				
			if( xhr.readyState == 4 && xhr.status == 200 ){
				var data = xhr.responseText;
				var json = eval("["+data+"]");
				
				var movie_container = "movie_list_"+1;//영화 정보 담는 컨테이너

		    	var moviePoster = cutPoster(json[0].Data[0].Result[0].posters);//json형식으로 넘어온 값이 여러개의 포스터일 경우 하나의 포스터를 가져옴
		    	document.getElementById("movie_rank_poster_"+1+"_img").src=moviePoster;//포스터
		    	wholeCount++;
			}
		} */
		//--------------------------------------------------------------------
		
		
	</script>
</head>
<body>
	<div>
		<a href="/movie/movieReleaseList.do">상영 예정작</a>
		<a href="/movie/movieRankList.do">무비 차트(일간)(주간)</a>
		<a href="/movie/movieQuery.do">영화 검색</a>
	</div>
	
	<div id="container">
		<div id="contents">
			<div id="movie_chart">
				<div id="chart_title">무비 차트(일간)(주간)</div>
				<div id="select_movie_list">
					<ul id="movie_list">
						
						<li id="loadingText"><h3>Loading...</h3></li>
					
						<c:forEach var="n" begin="0" end="9" step="1">
							<li id="movie_list_${n}" style="margin:10px">
									<input type="hidden" id="movie_movieCd_${n}">
									<input type="hidden" id="movie_movieNm_${n}">
									<div id="movie_rank_movieNm_${n}"></div>
									<div id="movie_rank_postor_${n}">
										<img id="movie_rank_poster_${n}_img">
									</div>
									<div id="movie_rank_rank_${n}"></div>
									<div id="movie_rank_salesShare_${n}"></div>
									<div id="movie_rank_audiAcc_${n}"></div>
									<div id="movie_rank_openDt_${n}"></div>
							</li>
						</c:forEach>
					</ul>
				</div>
			
			</div>
		</div>
	</div>
	
</body>
</html>