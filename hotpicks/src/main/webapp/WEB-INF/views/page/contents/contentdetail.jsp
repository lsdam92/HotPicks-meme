<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file = "/WEB-INF/views/page/template/header.jsp"%>
<script type="text/javascript"
	src="//dapi.kakao.com/v2/maps/sdk.js?appkey=67cafe381089c40769059fbbedfa054e&libraries=services,clusterer,drawing"></script>
<style>
#pick{
	display: none;
}
#pk.selected #pick{
	display: inline-block!important;
}
#pk.selected #unpick{
	display: none;
}

</style>
<script>
$(document).ready(function() {
	//<<start : hit 조회수 올리기
	/* $.ajax({
			url : '${root}/contents/hit',
			type : 'GET',
			dataType : 'json',
			data : {contentsId : '${contentsDto.contentsId}'},
			success : function(response){
				alert("조회수 올라감!!");
			}
	}); */
	//>>end : hit 조회수 올리기
	
	//<<start : pick
	if ('${userInfo == null}' == 'false'){
		
		var data =  {
				"userId" : '${userInfo.userId}',
				"contentsid" : '${contentsDto.contentsId}'
				};
		$.ajax({
			url : '${root}/contents/getpick',
			type: 'GET',
			contentType:"application/json;charset=UTF-8",
			dataType : 'json',
			data : data,
			success : function(result){
				if (result == 1) {
					$('#pk').toggleClass('selected');
				}
			}
		
		});
		
	}
	
	
	$("#pk > img").click(function () {
		if ('${userInfo == null}' == 'true'){
			alert("로그인을 해주세요!");
		} else {
			$(this).parent().toggleClass('selected');
			if ($(this).parent().hasClass('selected') === true){
				$.ajax({
					url : '${root}/contents/insertpick',
					type : 'post',
					data : data,
					success : function(result){
						if (result == 1) {
							console.log("pick insert : "+result);
						} else{
							alert("pick insert : false")
						}
						
						
					}
				});
			} else{
				console.log(data);
				$.ajax({
					url : '${root}/contents/deletepick',
					type : 'post',
					data : data,
					success : function(result){
						if (result == 1) {
							console.log("pick delete : "+result);
						} else{
							alert("pick delete : false")
						}
						
					}
				});
			}
		}
	});
	
	
	//>>end : pick
	
	//<<start : 리뷰작성
	getWriteList();
	
	function getWriteList() {
		$.ajax({
			url : '${root}/review/list',
			type : 'GET',
			dataType : 'json',
			data : {contentsId : '${contentsDto.contentsId}'},
			success : function(response){
				makeWriteList(response);
			}
		});
	}
	

	
	$("#writeBtn").click(function() {
		 //var writeForm = $("#writeForm").serialize();
		if ( $("#picture").val() != "" ) { //파일업로드 확장자 체크
	        var ext = $('#picture').val().split('.').pop().toLowerCase();
	        if($.inArray(ext, ['gif','png','jpg']) == -1) {
	    	     alert('등록 할수 없는 파일명입니다. 이미지 파일은 (jpg, png, gif) 형식만 등록 가능합니다.');
	    	     $("#picture").val(""); // input file 파일명을 다시 지워준다.
	    	     return;
	   	  	}
	    }
		
		//alert("들어가!");
		if ('${userInfo == null}' == 'true'){
			alert("로그인하세요.");
			
		} else if($("#subject").val() == "") {
			alert("제목 입력!!!");
			return;
		} else if($("#content").val() == "") {
			alert("내용 입력!!!");
			return;
		} else {
	    	//alert("dkdkd");
			$("#writeForm").attr("action","${root}/review/write").submit();
			
		}
	});
	
	//리뷰 만들기
	function makeWriteList(reviews) {
		var reviewcnt = reviews.reviewlist.length;
		
		var reviewstr = '';
		for(var i=0; i<reviewcnt; i++) {
			var review = reviews.reviewlist[i];
			reviewstr += '<li class="clearfix">';
			reviewstr += '<div class="toggle">';
			reviewstr += '	<div class="rehead" style="height:100px; margin-bottom:2%;" data-toggle="collapse" data-target="#'+i+'">';
			reviewstr += '		<div class="user" style="width:110px;height:110px; padding:1%; float:left; text-align:center;">';
			if(review.saveFolder != null) {
			reviewstr += '			<img src="${root}/review/'+review.saveFolder+'/'+review.savePicture+'" class="avatar" /> ';
			//${root}/review/파일폴더/파일명
			} else {				
			reviewstr += '			<img src="${root}/resources/style/images/art/blog-th1.jpg" class="avatar" /> ';
			}
			reviewstr += '		</div>';
			reviewstr += '		<div class="message">';
			reviewstr += '			<div class="info">';
			reviewstr += '				<h3><a>'+review.subject+'</a></h3>';
			
			reviewstr += '				<span class="date">  - '+review.logTime+'</span>';
			reviewstr += '				<span class="reviewseq" style="visibility:hidden;">'+review.rseq+'</span>';
			
			if('${userInfo.userId}' == review.userId) {
				reviewstr += '			<input type="button" class="modifyBtn" value="수정" data-toggle="modal" data-target="#modifymodal'+i+'" style="float:right;">';
				reviewstr += '			<input type="button" class="deleteBtn" value="삭제" style="float:right;">';
				
				
				//modifymodal
				reviewstr += '<div class="modal" id="modifymodal'+i+'">';
				reviewstr += '    <div class="modal-dialog modal-xl">';
				reviewstr += '      <div class="modal-content">';
				      
				reviewstr += '        <div class="modal-header">';
				reviewstr += '          <h4 class="modal-title">리뷰 수정</h4>';
				reviewstr += '      	<button type="button" class="close" data-dismiss="modal">&times;</button>';
				reviewstr += '        </div>';
				        
				       
				reviewstr += '        <div class="modal-body">';
				reviewstr += '			<h5>제목 : <input value="'+review.subject+'"></h5>';
				reviewstr += '			<label style="font-size:15px;">별점</label>';
				reviewstr += '			<select class="form-control" >';
				reviewstr += '				<option value="5">★★★★★</option>';
				reviewstr += '				<option value="4">★★★★</option>';
				reviewstr += '				<option value="3">★★★</option>';
				reviewstr += '				<option value="2">★★</option>';
				reviewstr += '				<option value="1">★</option>';
				reviewstr += '			</select><br>';
				//해쉬태그 수정도 해야함!!
				reviewstr += '			<textarea cols="80" rows="5">'+review.content.replace('<', '&lt;')+'</textarea>';       
				reviewstr += '        </div>';   
				        
				       
				reviewstr += '        <div class="modal-footer" data-seq="'+review.rseq+'">';
				reviewstr += '      	<button type="button" class="btn btn-primary modifyokbtn" >완료</button>';
				reviewstr += '      	<button type="button" class="btn btn-danger" data-dismiss="modal">취소</button>';
				reviewstr += '        </div>';
				        
				reviewstr += '      </div>';
				reviewstr += '    </div>';
				reviewstr += '  </div>';
				
			} else if('${userInfo == null}' == 'false'){
				reviewstr += '	<input type="button" class="blackBtn" value="신고하기" data-toggle="modal" data-target="#blackmodal'+i+'" style="float:right;">';
				
				//blackmodal
				reviewstr += '<div class="modal" id="blackmodal'+i+'">';
				reviewstr += '    <div class="modal-dialog modal-xl">';
				reviewstr += '      <div class="modal-content">';
				      
				reviewstr += '        <div class="modal-header">';
				reviewstr += '          <h4 class="modal-title">리뷰 신고하기</h4>';
				reviewstr += '      	<button type="button" class="close" data-dismiss="modal">&times;</button>';
				reviewstr += '        </div>';
				        
				       
				reviewstr += '        <div class="modal-body">';
				//리뷰글번호 회원아이디 신고내용 신고일자 
				reviewstr += '			<label style="font-size:15px;">신고내용</label>';
				reviewstr += '			<textarea cols="80" rows="5"></textarea>';  
				reviewstr += '        </div>';   
				        
				       
				reviewstr += '        <div class="modal-footer" data-seq="'+review.rseq+'" data-user="${userInfo.userId}">';
				reviewstr += '      	<button type="button" class="btn btn-primary blackreviewbtn" >신고</button>';
				reviewstr += '      	<button type="button" class="btn btn-danger" data-dismiss="modal">취소</button>';
				reviewstr += '        </div>';
				        
				reviewstr += '      </div>';
				reviewstr += '    </div>';
				reviewstr += '  </div>';
			
			}
			
			reviewstr += '			</div>';
			reviewstr += '			<p>';
			for(var j=0; j<review.starPoint; j++) {
				reviewstr += '★';
			}
			reviewstr += '			</p>';
			
			reviewstr += '			<p>글쓴이 : '+review.userId+'</p>';
			reviewstr += '			<p>'+review.hashTag+'</p>';
			
			reviewstr += '		</div>';
			reviewstr += '	</div>';
			reviewstr += '	<div id="'+i+'" class="collapse" data-parent="#singlecomments">';
			reviewstr += '		<div style="background-color: lightgray; ">'+review.content+'</div>';
			reviewstr += '		<div style="height:20px;"></div>';
			reviewstr += '		<div style="background-color: white; height:130px;">';
			reviewstr += '			<textarea class="mcontent" cols="68" rows="5"></textarea>';
			reviewstr += '			<span class="reviewseq" style="visibility:hidden;">'+review.rseq+'</span>';
			reviewstr += '			<input type="button" class="memoBtn" value="글작성">';
			reviewstr += '		</div>';
			reviewstr += '		<div class="mlist">gogogo</div>';
			reviewstr += '	</div>';
			reviewstr += '</div>';
			reviewstr += '</li>';
		}
		
	
		$("#singlecomments").empty();
		$("#singlecomments").append(reviewstr);
		
		
		//리뷰 신고
		//리뷰글번호 회원아이디 신고내용 신고일자 
		var blackArr = $(".blackreviewbtn");
		$(blackArr).live("click",function() {
			$.ajax({
				url : '${root}/review/black/' 
				+ $(this).parent(".modal-footer").attr("data-seq") + '/' 
				+ $(this).parent(".modal-footer").attr("data-user") + '/' 
				+ $(this).parent(".modal-footer").siblings(".modal-body").find("textarea").val(),
				type : 'PUT',
				contentType : 'application/json;charset=UTF-8',
				dataType : 'json',
				success : function(response) {
					alert("신고가 완료되었습니다.");
					window.location.reload();
				}
			});
			
		});
		
		
		//댓글list 가져오기
		var rehArr = $(".rehead");
		$(rehArr).live("click", function() {
			var index = $(this).find(".reviewseq").text();
			getMemoList(index);
		});
		
		//댓글 쓰기
		var makeArr = $(".memoBtn");
		$(makeArr).live("click",function() {
			if('${userInfo == null}' == 'true') {
				alert("로그인하세요.");
			} else {	
				var rceq = $(this).siblings(".reviewseq").text();
				console.log("rceq : "+rceq);
				var content = $(this).siblings(".mcontent").val();
				console.log("mcontent : " + content);
				var param = JSON.stringify({'rceq' : rceq, 'content' : content});
				console.log("param : " + param);
				
				if(content.trim().length != 0) {
					$.ajax({
						url : '${root}/review/memo',
						type : 'POST',
						contentType : 'application/json;',
						dataType : 'json',
						data : param,
						success : function(response) {
							makeMemoList(response);
							$(".mcontent").val('');
							
						}
					});
				}
			} 
		});
		
		//리뷰 수정하기
		var modifyArr = $(".modifyokbtn");
		$(modifyArr).live("click",function() {
			//alert("modify review");
	
			$.ajax({
				url : '${root}/review/modify/' 
					+ $(this).parent(".modal-footer").attr("data-seq") + '/' 
					+ $(this).parent(".modal-footer").siblings(".modal-body").find("input").val() + '/' 
					+ $(this).parent(".modal-footer").siblings(".modal-body").find("select").val() +'/' 
					+ $(this).parent(".modal-footer").siblings(".modal-body").find("textarea").val(),
				type : 'PUT',
				contentType : 'application/json;charset=UTF-8',
				dataType : 'json',
				success : function(response) {
					alert("수정이 완료되었습니다.");
					window.location.reload();
				}
			});
		}); 
			
		
		
		//리뷰 삭제
		var deleteArr = $(".deleteBtn");
		$(deleteArr).live("click",function() {
			$.ajax({
				url : '${root}/review/delete/' + $(this).siblings(".reviewseq").text(),
				type : 'DELETE',
				contentType : 'application/json;charset=UTF-8',
				dataType : 'json',
				success : function(response) {
					alert("삭제가 완료되었습니다.");
					window.location.reload();
				}
			});
			
		});
		
		
	}
	
	
	function getMemoList(index) {
			$.ajax({
				url : '${root}/review/memo',
				type : 'GET',
				contentType : 'application/json;charset=UTF-8',
				dataType : 'json',
				data : {rceq : index},
				success : function(response) {
					makeMemoList(response);
					$(".mcontent").val('');
				}
			});
	}
	
	function makeMemoList(memos) {
		var memocnt = memos.memolist.length;
		var memostr = '';
		
		for(var i=0; i<memocnt; i++) {
			var memo = memos.memolist[i];
			memostr += '<tr>';
			memostr += '	<td>' + memo.logId + '</td>';
			memostr += '	<td style="padding: 10px">';
			memostr += memo.content;
			memostr += '	</td>';
			memostr += '	<td width="100" style="padding: 10px">';
			memostr += memo.logTime;
			memostr += '	</td>';
			
			if('${userInfo.userId}' == memo.logId) {
				memostr += '	<td width="100" style="padding: 10px" data-seq="'+memo.rceq+'" data-id="'+memo.logId+'" data-time="'+memo.logTime+'">';
				memostr += '		<input type="button" class="mmodifyBtn" value="수정">';
				memostr += '		<input type="button" class="mdeleteBtn" value="삭제">';
				memostr += '	</td>';
			}
			memostr += '</tr>';
			memostr += '<tr style="display: none; border: solid thick black;">';
			memostr += '	<td colspan="3">';
			memostr += '	<textarea class="mcontent" cols="160" rows="3">'+memo.content+'</textarea>';
			memostr += '	</td>';
			memostr += '	<td width="100" style="padding: 10px" data-seq="'+memo.rceq+'" data-id="'+memo.logId+'" data-time="'+memo.logTime+'">';
			memostr += '	<input type="button" class="memoModifyBtn" value="완료">';
			memostr += '	<input type="button" class="memoModifyCancelBtn" value="취소">';
			memostr += '	</td>';
			memostr += '</tr>';
			memostr += '<tr>';
			memostr += '	<td class="bg_board_title_02" colspan="4" height="1"';
			memostr += '		style="overflow: hidden; padding: 0px"></td>';
			memostr += '</tr>';
		}
		$(".mlist").empty();
		console.log($(".mlist").text());
		$(".mlist").append(memostr);
		
		///////////////////////////////////////////
		// 댓글 수정 작성란 보이기
		var viewmodify = $(".mmodifyBtn");
		$(viewmodify).live("click",function() {
			$(this).parent().parent().next("tr").css("display", "");
			$(this).parent().parent("tr").css("display", "none");
		});
		
		// 댓글 수정 취소 이벤트
		var modifycancel = $(".memoModifyCancelBtn");
		$(modifycancel).live("click",function() {
			$(this).parent().parent("tr").css("display", "none");
			$(this).parent().parent().prev("tr").css("display", "");
		});

		
		// 댓글 수정 이벤트
		var memomodify = $(".memoModifyBtn");
		$(memomodify).live("click",function() {
			console.log("댓글수정!"+$(this).parent("td").attr("data-time"));
			$(this).parent().parent().prev("tr").css("display", "");
			
			//리뷰글번호,작성자id,작성시간,글내용
			
			var newMcontent = $(this).parent().prev("td").children().val();
			
			$.ajax({
				url : '${root}/review/modifyMemo/' + $(this).parent("td").attr("data-seq") + '/' + $(this).parent("td").attr("data-id") +'/'+ $(this).parent("td").attr("data-time") +'/' + newMcontent,
				type : 'PUT',
				contentType : 'application/json;charset=UTF-8',
				dataType : 'json',
				success : function(response) {
					window.location.reload();
				}
			});
			
		
		});

		// 댓글 삭제 이벤트
		var memodelete = $(".mdeleteBtn");
		$(memodelete).live("click",function() {
			console.log("댓글삭제!");
			//리뷰글번호,작성자id,작성시간
			$.ajax({
				url : '${root}/review/deleteMemo/' + $(this).parent("td").attr("data-seq") + '/' + $(this).parent("td").attr("data-id") +'/'+ $(this).parent("td").attr("data-time"),
				type : 'DELETE',
				contentType : 'application/json;charset=UTF-8',
				dataType : 'json',
				success : function(response) {
					alert("삭제가 완료되었습니다.");
					window.location.reload();
				}
			});
			
		});
		
		
	
	}
	//>>end : 리뷰작성
	
	//<<start : hashTag
	$('.hstgcancel').live('click', function(e){
		e.preventDefault();
		$(this).parent().parent().remove();
	});
	
	$('#hashTag').keypress(function(e){
		if(e.keyCode==32){
			if ($('.hstg').length <= 4) {
				console.log('스페이스바 눌림');
				var hstg = "<div class='hstgdiv'><input type='hidden' name='hstg' value="
					+ $('#hashTag').val().trim()+"><label class='hstg'>"
					+ $('#hashTag').val().trim() 
					+"<a class='hstgcancel' href='#'>"
					+"<img class='hstgimg' src='${root}/resources/style/images/icon_x.png'></a></label></div>";
				$('.hsgroup').append(hstg);
				$('#hashTag').val('');
			} else {
				console.log($('.hstg').html());
				console.log($('.hstg').length);
				alert('안됨');
			}
			
		}
	});
	//>>end : HashTag
	
	//<<start : 다른이미지
	$(".altImg").click(function() {
		var altImage = $(this).attr('src'); 
		$(".detailimg").attr('src', altImage);
	});
	//>>end : 다른이미지
	
});
</script>
<style>
/* 세현 */
.hstg{
	height: 20px;
	text-align:center;
	font-size: 13px;
	background-color: #ffd100;
	border-radius:10px;
	box-shadow: 0 1px 6px rgba(0, 0, 0, 0.8);
	margin-left: 5px;
	padding:2px 5px 2px 5px;
}
.hstgimg{
	height: 8px;
	padding-left: 5px;
	padding-right: 5px;
}
.hsgroup{
	display: inline-block;
	padding:0px!important;
}
.hstgdiv{
	display: inline-block;
	padding:0px!important;
}


.detailimg {
	width: 560px;
	height: 270px;
}


.writeReview {
	float: right;
	font-size: 15px;
	margin-bottom: 10px;
}
li.clearfix {
	padding: 10px !important;
	margin: 0px !important;
}
.message{
	padding-top: 10px !important;
}
.avatar{
	height: 100px;
	width: 100px;
}
.commReply{
	float: right;
	margin-right: 30px;
}
.togglebox{
	width: 620px !important;
}
#commenth3{
	margin-bottom: 50px !important;
}
.mcontent{
	width: 80%;
	float: left;
}
.memoBtn{
	margin-right: 20px;
	margin-top: 35px;
	float: right;
}

</style>
<script type="text/javascript">
	$(function() {
		$("label").inFieldLabels();
	});
</script>

<!-- Begin Wrapper -->
<div id="wrapper">
	<div id="post-wrapper">
	<!-- Begin 상세정보 -->
		<div class="post">
			<div style="float: left;">
				<h1 class="title" style="margin-top: 20px;">${contentsDto.title}</h1>
			</div>
			<div id="pk" style="float: right;">
				<img class="" id="pick" src="${root}/resources/style/images/heart64.png">
				<img class="" id="unpick" src="${root}/resources/style/images/unheart64.png">
			</div>
			<div style="clear: both;"></div>
			<div class="meta">
				<div class="top-border"></div>
				<span class="contentsType">${contentsType}</span> | <span class="picksCount">${picklistNum}</span>
				Picks | ${contentsDto.hit} views | <span class="reviewCount">${reviewNum}</span> Reviews
			</div>
			<img class="detailimg" src="${contentsDto.image1 != '-1' ? contentsDto.image1 : (contentsDto.image2 != '-1' ? contentsDto.image2 : '') }" />
			<div class="detail">
			<c:if test="${contentsDetailDto.eventStartDate != '-1' && contentsDetailDto.eventEndDate != '-1'}">
				<div><span style="font-weight: bold; font-size: 15px;">기간 |</span> ${contentsDetailDto.eventStartDate} ~ ${contentsDetailDto.eventEndDate}</div>
			</c:if>
			<c:if test="${contentsDetailDto.zipCode != '-1' || contentsDetailDto.addr1 != '-1' || contentsDetailDto.addr2 != '-1'} ">
				<div><span style="font-weight: bold; font-size: 15px;">장소 |</span> (${contentsDetailDto.zipCode}) ${contentsDetailDto.addr1} ${contentsDetailDto.addr2}</div>
			</c:if>
			<c:if test="${contentsDetailDto.homePage != '-1'}">
				<div><span style="font-weight: bold; font-size: 15px;">홈페이지 |</span> ${contentsDetailDto.homePage}</div>
			</c:if>
			<c:if test="${contentsDetailDto.telName != '-1' || contentsDetailDto.tel != '-1'}">
				<div><span style="font-weight: bold; font-size: 15px;">주최자 tel |</span> ${contentsDetailDto.telName} ${contentsDetailDto.tel}</div>
			</c:if>
			<c:if test="${contentsDetailDto.program != '-1'}">
				<div><span style="font-weight: bold; font-size: 15px;">행사프로그램 |</span> ${contentsDetailDto.program}</div>
			</c:if>
			<c:if test="${contentsDetailDto.usetime != '-1'}">
				<div><span style="font-weight: bold; font-size: 15px;">이용요금 |</span> ${contentsDetailDto.usetime}</div>
			</c:if>
			<c:if test="${contentsDetailDto.playtime != '-1'}">
				<div><span style="font-weight: bold; font-size: 15px;">공연시간 |</span> ${contentsDetailDto.playtime}</div>
			</c:if>
			<c:if test="${contentsDetailDto.spendtime != '-1'}">
				<div><span style="font-weight: bold; font-size: 15px;">관람소요시간 |</span> ${contentsDetailDto.spendtime}</div>
			</c:if>
			<c:if test="${contentsDetailDto.ageLimit != '-1'}">
				<div><span style="font-weight: bold; font-size: 15px;">관람가능연령 |</span> ${contentsDetailDto.ageLimit}</div>
			</c:if>	
			<c:if test="${contentsDetailDto.discountInfo != '-1'}">
				<div><span style="font-weight: bold; font-size: 15px;">할인정보 |</span> ${contentsDetailDto.discountInfo}</div>
			</c:if>
			<c:if test="${contentsDetailDto.placeInfo != '-1'}">
				<div><span style="font-weight: bold; font-size: 15px;">행사장위치안내 |</span> ${contentsDetailDto.placeInfo}</div>
			</c:if>
			<c:if test="${contentsDetailDto.infoSogae != '-1'}">
				<div><span style="font-weight: bold; font-size: 15px;">행사소개 |</span> ${contentsDetailDto.infoSogae}</div>
			</c:if>
			<br>
			<c:if test="${contentsDetailDto.infoNaeyong != '-1'}">
				<div><span style="font-weight: bold; font-size: 15px;">행사내용 |</span> ${contentsDetailDto.infoNaeyong}</div>
			</c:if>		
				
				<p></p>
			</div>
			<div class="top-border"></div>
			<div class="tags">
				Tags: 
				<c:forEach var="hashtag" items="${hashTagDto}">
				<a href="#" title="">${hashtag.hashTag}&nbsp;&nbsp;</a>
				</c:forEach>
			</div>
		</div>
	<!-- End 상세정보 -->
	
		<!-- Begin 후기 -->
		<div id="comment-wrapper">
			<h3 id="commenth3">
				<span class="reviewCount">${reviewNum}</span> Reviews to "<span>${contentsDto.title}</span>"
				<!-- Begin 후기 작성 -->	
				<div class="toggle">
					<div class="trigger"><button type="button" class="btn btn-primary writeReview">리뷰 작성</button></div>
					<div class="togglebox">
          				<div>
          				<form id="writeForm" name="writeForm" method="post" action="" enctype="multipart/form-data">
          					<input type="hidden" name="rseq" value="1">
          					<input type="hidden" name="contentsid" value="${contentsDto.contentsId}">
          					<input type="hidden" name="pg" value="1">
          					<input type="hidden" name="key" value="">
          					<input type="hidden" name="word" value="">
          					<div class="reviewInput">
          						<div>리뷰 작성</div>
          						<label style="font-size:15px;">제목</label>
          						<input type="text" name="subject" id="subject"><br>
          					
  								<label style="font-size:15px;">별점</label>
  								<select class="form-control" id="sel1" name="starPoint">
    								<option value="5">★★★★★</option>
    								<option value="4">★★★★</option>
    								<option value="3">★★★</option>
    								<option value="2">★★</option>
    								<option value="1">★</option>
  								</select>		
          						<br>
          						<label style="font-size:15px;">해쉬태그</label><div class="hsgroup"></div>
          						<input type="text" id="hashTag"><br>
								<label style="font-size:15px;">사진 올리기</label>
								<input type="file" name="picture" id="picture" accept="image/*"><br>
								<label style="font-size:15px;">내용</label><br>
								<textarea name="content" id="content" class="reviewcontents" cols="50" rows="15" ></textarea>
          					</div>
          				</form>
						<input id="cancelBtn" class="cancelBtn" type="button"
						name="cancel" value="취소" style="float:right; margin-left:10px;"/>
          				<input id="writeBtn" class="writeBtn" type="button"
						name="write" value="등록" style="float:right;"/>
						<div class="clear"></div>
          				</div>
        			</div>
				</div>
				<!-- End 후기 작성 -->
			</h3>
			
			<!-- Begin 후기 리스트 -->	
			<div id="comments">
				<ol id="singlecomments" class="commentlist">
					
				</ol>
			</div>
			<!-- End 후기 리스트 -->	

		</div>
	<!-- End 후기 -->
	</div>
	
	<!-- 사이드 바 -->
	<div id="sidebar">
		<div class="sidebox">
			<h3>다른 사진들</h3>
			<ul class="flickr" style="width:240px;">
				<c:choose>
					<c:when test="${!contentsImageDto.isEmpty()}">
					<c:forEach var="contentsImg" items="${contentsImageDto}">
						<li style="width: 70px;height: 70px;"><a href="#">
							<img class="altImg" src="${contentsImg.smallImageUrl}" height="70px" width="70px"/>
						</a></li>   
					</c:forEach>
					</c:when>
					<c:otherwise>
					<h5>다른 이미지가 없습니다.</h5>
					</c:otherwise>
				</c:choose>
			</ul>
		</div>
		<div class="sidebox">
			<h3>지도</h3>
			<div id="map" style="height: 260px; background-color: lightgray;"></div>
		</div>
		<div class="sidebox">
			<h3>Hash Tags</h3>
			<ul class="tags">
				<c:choose>
					<c:when test="${!hashTagDto.isEmpty()}">
					<c:forEach var="hashtag" items="${hashTagDto}">
						<li><a href="#" title="">${hashtag.hashTag}</a></li>
					</c:forEach>
					</c:when>
					<c:otherwise>
					<h5>아직 HashTag가 없습니다!<br>
					리뷰를 작성해서 HashTag를 체워주세요!</h5>
					</c:otherwise>
				</c:choose>
			</ul>
		</div>
		<div class="sidebox">
			<h3>예매정보</h3>
			<ul class="post-list archive">
				<c:choose>
					<c:when test="${contentsDetailDto.bookingPlace != '-1'}">
						<li><a href="#" title="">${contentsDetailDto.bookingPlace}</a></li>
					</c:when>
					<c:otherwise>
					<li><a href="#" title="">예매정보가 없습니다.</a></li>
					</c:otherwise>
				</c:choose>
			</ul>
		</div>

	</div>
	<!-- 사이드 바 -->
</div>
<!-- End Wrapper -->
<script>
var position = new kakao.maps.LatLng('${contentsDetailDto.yPoint}', '${contentsDetailDto.xPoint}');
var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
mapOption = { 
    center: position, // 지도의 중심좌표
    level: 5 // 지도의 확대 레벨
};

//지도를 표시할 div와  지도 옵션으로  지도를 생성합니다
var map = new kakao.maps.Map(mapContainer, mapOption); 
var imageSrc = '${root}/resources/style/images/marker/done_mark2.png', // 마커이미지의 주소입니다    
imageSize = new kakao.maps.Size(28, 35), // 마커이미지의 크기입니다
imageOption = {offset: new kakao.maps.Point(10,45)}; // 마커이미지의 옵션입니다. 마커의 좌표와 일치시킬 이미지 안에서의 좌표를 설정합니다.

//마커의 이미지정보를 가지고 있는 마커이미지를 생성합니다
var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imageOption),
markerPosition = position; // 마커가 표시될 위치입니다

//마커를 생성합니다
var marker = new kakao.maps.Marker({
position: markerPosition,
image: markerImage // 마커이미지 설정 
});

//마커가 지도 위에 표시되도록 설정합니다
marker.setMap(map);

$(document).ready(function() {
	console.log("1");
	var mousestatus;
	
	
	$('#map').mousedown(function(e) {
		mousestatus = e.type;
	console.log("down : "+mousestatus);
	});
	$('#map').mouseup(function(e) {
		mousestatus = e.type;
	console.log("up : "+mousestatus);
	});
	
	$('#map').mouseleave(function() {
		if (mousestatus != 'mousedown') {
			console.log(mousestatus);
			map.panTo(position);
			
			console.log("leave : "+mousestatus);
		}
		mousestatus = 'reset';
	});	
	 
	
})

</script>

<%@ include file = "/WEB-INF/views/page/template/footer.jsp"%>