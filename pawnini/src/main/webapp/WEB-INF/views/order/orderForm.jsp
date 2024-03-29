<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script src="//code.jquery.com/jquery-3.3.1.min.js"></script>
<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
<script
	src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<style>
.orderInfo {
	border: 5px solid #eee;
	padding: 20px;
}

.orderInfo .inputArea {
	margin: 10px 0;
}

.orderInfo .inputArea label {
	display: inline-block;
	width: 120px;
	margin-right: 10px;
}

.orderInfo .inputArea input {
	font-size: 14px;
	padding: 5px;
}

#userAddr2, #userAddr3 {
	width: 250px;
}

.orderInfo .inputArea:last-child {
	margin-top: 30px;
}

.orderInfo .inputArea button {
	font-size: 20px;
	border: 2px solid #ccc;
	padding: 5px 10px;
	background: #fff;
	margin-right: 20px;
}
</style>
<script>
	$(document).ready(
			function() {

				/* 최종 결제 금액 표시 */
				var finalSum = $("#finalSum").val();
				$("#ord_total").text(Number(finalSum).toLocaleString('en'));
				$("#ord_total2").val(finalSum);

				/* 배송지 정보 */
				$("input[type=radio][name=del_info]").change(
						function() {
							if (this.value == "del_default") {
								/* 기본 배송지(회원가입 시 입력한 정보) 불러오기 */
								$("input[name=recipient_name]").val(
										$("#h_member_name").val());
								$("input[name=recipient_name]").attr(
										"readonly", true);
								$("input[name=ord_phone]").val(
										$("#h_member_phone").val());
								$("input[name=ord_phone]").attr("readonly",
										true);
								$("input[name=ord_email]").val(
										$("#h_member_email").val());
								$("input[name=ord_email]").attr("readonly",
										true);
								$("input[name=ord_postcode]").val(
										$("#h_member_postcode").val());
								$("input[name=ord_postcode]").attr("readonly",
										true);
								$("input[name=ord_f_addr]").val(
										$("#h_member_f_addr").val());
								$("input[name=ord_f_addr]").attr("readonly",
										true);
								$("input[name=ord_s_addr]").val(
										$("#h_member_s_addr").val());
								$("input[name=ord_s_addr]").attr("readonly",
										true);
								$("#schPost").css("visibility", "hidden");
							} else if (this.value == "del_new") {
								/* 신규 배송지 입력 */
								$("input[name=recipient_name]").val("");
								$("input[name=recipient_name]").attr(
										"readonly", false);
								$("input[name=ord_phone]").val("");
								$("input[name=ord_phone]").attr("readonly",
										false);
								$("input[name=ord_email]").val("");
								$("input[name=ord_email]").attr("readonly",
										false);
								$("input[name=ord_postcode]").val("");
								$("input[name=ord_postcode]").attr("readonly",
										true);
								$("input[name=ord_f_addr]").val("");
								$("input[name=ord_f_addr]").attr("readonly",
										false);
								$("input[name=ord_s_addr]").val("");
								$("input[name=ord_s_addr]").attr("readonly",
										false);
								$("#schPost").css("visibility", "visible");
							}
						});

				/* 이용약관 전체 동의 체크박스 */
				$("#checkAllTerms").click(function() {
					if ($("#checkAllTerms").prop("checked")) {
						$("input[name=checkTerms]").prop("checked", true);
					} else {
						$("input[name=checkTerms]").prop("checked", false);
					}
				});

			});

	/* 다음 도로명 주소 찾기 */
	function execPostCode() {
		new daum.Postcode({
			oncomplete : function(data) {
				var fullRoadAddr = data.roadAddress;
				var extraRoadAddr = '';

				if (data.bname !== '' && /[동|로|가]$/g.test(data.bname)) {
					extraRoadAddr += data.bname;
				}
				if (data.buildingName !== '' && data.apartment === 'Y') {
					extraRoadAddr += (extraRoadAddr !== '' ? ', '
							+ data.buildingName : data.bulidingName);
				}
				if (extraRoadAddr !== '') {
					extraRoadAddr = ' (' + extraRoadAddr + ')';
				}
				if (fullRoadAddr !== '') {
					fullRoadAddr += extraRoadAddr;
				}

				console.log(data.zonecode);
				console.log(fullRoadAddr);

				$("[name=ord_postcode]").val(data.zonecode);
				$("[name=ord_f_addr]").val(fullRoadAddr);
			}
		}).open();
	};

	/* 적립금 사용금액 입력 */
	function chkMileage(input, mileage) {
		var tmpMileage = parseInt(input.value);
		if (tmpMileage > mileage || tempMileage > 10000) {
			alert('사용 가능한 적립금을 초과했습니다.');
			input.value = 0;
			return;
		}

	}

	/* 적립금 전체 사용 체크 */
	function useAllMileage(mileage) {

		if ($("#chkAll").is(":checked") == true) {
			$("#ord_used_mileage").val(mileage);
		} else {
			$("#ord_used_mileage").val(0);
			$("#ord_used_mileage").select();
		}
	}

	/* 사용한 적립금 취소 */
	function cancelMileage(finalSum) {
		$("#ord_total").text(Number(finalSum).toLocaleString('en'));
		$("#ord_total2").val(finalSum);
		$("#ord_used_mileage").val(0);
		$("#ord_used_mileage2").val(0);
		$("#ord_used_mileage").attr("readonly", false);
		$("input[name=chkAll]").prop("checked", false);
	}

	/* 적립금 사용 후 최종 결제 금액 구하기 */
	function calcFinalSum(ord_used_mileage, finalSum) {

		var total = finalSum - ord_used_mileage;
		$("#ord_total").text(Number(total).toLocaleString('en'));
		$("#ord_total2").val(total);
		$("#ord_used_mileage").attr("readonly", true);
		$("#ord_used_mileage2").val(ord_used_mileage);
		$("input[name=chkAll]").prop("checked", false);
	}

	/* 주문서 작성 취소 */
	function orderCancel() {
		window.history.back();
	};

	/* 카드 정보 숫자 입력 제한 */
	function onlyNumber() {
		if ((event.keyCode < 48) || (event.keyCode > 57)) {
			event.returnValue = false;
		}
	};

	/* 주문하기 버튼 클릭 시 실행(필수 정보 입력 여부 체크) */
	function finalCheck() {
		var checkTerms1 = $("#checkTerms1").is(":checked");
		var checkTerms2 = $("#checkTerms2").is(":checked");
		var member_id = $("#member_id").val();
		var recipient_name = $("input[name=recipient_name]").val();
		var ord_phone = $("input[name=ord_phone]").val();
		var ord_postcode = $("input[name=ord_postcode]").val();
		var ord_f_addr = $("input[name=ord_f_addr]").val();
		var ord_s_addr = $("input[name=ord_s_addr]").val();
		var ord_req_msg = $("#ord_req_msg").val();
		var ord_card_info1 = $("#ord_card_info1").val();
		var ord_card_info2 = $("#cardno1").val() + "-" + $("#cardno2").val()
				+ "-" + $("#cardno3").val() + "-" + $("#cardno4").val();
		var ord_used_mileage = $("#ord_used_mileage2").val();
		var ord_total = $("#ord_total2").val();

		if (checkTerms1 == true && checkTerms2 == true
				&& $("#cardno1").val() != "" && $("#cardno2").val() != ""
				&& $("#cardno3").val() != "" && $("#cardno4").val() != ""
				&& $("#cardno5").val() != "") {

			swal({
				icon : "info",
				text : "결제를 진행하시겠습니까?",
				closeOnClickOutside : false,
				CloseOnEsc : false,
				buttons : [ "결제하기", "취소하기" ],
			}).then(function(isConfirm) {
				$.ajax({
					type : "post",
					url : "insertOrder.do",
					data : {
						"member_id" : member_id,
						"recipient_name" : recipient_name,
						"ord_phone" : ord_phone,
						"ord_postcode" : ord_postcode,
						"ord_f_addr" : ord_f_addr,
						"ord_s_addr" : ord_s_addr,
						"ord_req_msg" : ord_req_msg,
						"ord_card_info1" : ord_card_info1,
						"ord_card_info2" : ord_card_info2,
						"ord_used_mileage" : ord_used_mileage,
						"ord_total" : ord_total,
					},
					success : function(data) {
						swal({
							icon : "success",
							title : "",
							text : "결제 완료",
							timer : 3000,
						});
						window.location.href = "main.do";
					},
				});
			})

		} else if (checkTerm1 == false || checkTerm2 == false) {
			swal("", "이용약관에 동의해 주시기 바랍니다.", "info");
		} else {
			swal("", "카드 정보를 확인해 주시기 바랍니다.", "info");
		}
	}
</script>
</head>
<%@ include file="../include/Header.jsp"%>
<body>


	<section id="content">
		<br> 주문상품
		<table border="1">
			<tr>
				<th></th>
				<th>상품명</th>
				<th>판매가</th>
				<th>수량</th>
				<th>합계</th>
				<c:forEach var="row" items="${map.cartList}" varStatus="i">
					<tr>
						<td><img style="width: 100px; height: 150px;"
							src="${row.product_thumb_img}" />
						<td>${row.product_name}
						<td style="width: 80px" align="right"><fmt:formatNumber
								pattern="###,###,###" value="${row.product_price}" />
						<td>${row.cart_amount} <input type="hidden" id="product_id"
							name="product_id" value="${row.product_id}" /> <input
							type="hidden" id="cart_id" name="cart_id" value="${row.cart_id}" />
							<input type="hidden" id="member_id" name="member_id"
							value="${member.member_id}" />
						<td style="width: 100px" align="right">
							<!-- 아이템당 수량 *가격  = cart_total--> <fmt:formatNumber
								pattern="###,###,###" value="${row.cart_total}" />
				</c:forEach>
		</table>

		<!-- 주문정보 입력 -->
		<form role="orderForm" method="post" autocomplete="off"
			action="insertOrder.do">
			<input type="hidden" id="h_member_name" value="${member.member_name}" />
			<input type="hidden" id="h_member_phone"
				value="${member.member_phone}" /> <input type="hidden"
				id="h_member_email" value="${member.member_email}" /> <input
				type="hidden" id="h_member_postcode"
				value="${member.member_postcode}" /> <input type="hidden"
				id="h_member_f_addr" value="${member.member_f_addr}" /> <input
				type="hidden" id="h_member_s_addr" value="${member.member_s_addr}" />
			주문정보
			<div class="orderInfo">
				<div class="inputArea">
					<label for="">주문자명</label> <input type="text" name="ord_name"
						id="orderRec" value="${member.member_name}" readonly />
				</div>
				<div class="inputArea">
					<label for="">연락처</label> <input type="text" name="ord_contact"
						id="orderRec" value="${member.member_phone}" readonly />
				</div>
				<div class="inputArea">
					<label for="orderPhone">이메일</label> <input type="email"
						name="ord_email" id="orderPhone" value="${member.member_email}"
						readonly />
				</div>
			</div>
			<!-- 배송정보 입력 -->
			배송정보
			<div class="orderInfo">
				<div class="inputArea">
					<input type="radio" name="del_info" id="del_new" value="del_new"
						checked />신규 배송지 <input type="radio" name="del_info"
						id="del_default" value="del_default" />기본 배송지
				</div>
				<div class="inputArea">
					<label for="">수령인명</label> <input type="text" name="recipient_name"
						id="orderRec" required />
				</div>

				<div class="inputArea">
					<label for="orderPhone">연락처</label> <input type="text"
						name="ord_phone" id="orderPhone" placeholder="010-1234-1234"
						required />
				</div>

				<div class="inputArea">
					<label for="userAddr1">우편번호</label> <input type="text"
						name="ord_postcode" id="userAddr1" placeholder="XXXXX" required
						readonly />
					<button type="button" id="schPost" class="btn btn-default"
						onclick="execPostCode()">
						<i class="fa fa-search"></i>우편번호 찾기
					</button>
				</div>

				<div class="inputArea">
					<label for="userAddr2">도로명 주소</label> <input type="text"
						name="ord_f_addr" id="userAddr2" placeholder="서울시 성동구 왕십리로 42"
						required readonly />
				</div>

				<div class="inputArea">
					<label for="userAddr3">상세 주소</label> <input type="text"
						name="ord_s_addr" id="userAddr3" placeholder="골댕이아파트 101동 101호"
						required />
				</div>

				<div class="inputArea">
					<label for="ord_req_msg">요청사항</label>
					<textarea name="ord_req_msg" id="ord_req_msg"
						placeholder="100자 이내로 작성해 주시기 바랍니다." cols="70" rows="4" /></textarea>
				</div>
			</div>
			<hr>

			<!-- 결제정보  -->
			결제정보
			<div class="orderInfo">
				<input type="hidden" id="finalSum" value="${map.finalSum}" />
				<div class="inputArea">
					상품주문금액 &nbsp;&nbsp;
					<fmt:formatNumber pattern="###,###,###" value="${map.sumTotal}" />
					원&nbsp; +&nbsp; ${map.shippingFee} 원 (5만원 이상 배송비 무료)
					&nbsp;&nbsp;&nbsp; = &nbsp;&nbsp;&nbsp; 최종결제금액 &nbsp;&nbsp;<span
						id="ord_total"></span>

				</div>
				<div class="inputArea" id="mileageArea">
					<b>적립금 </b> : <input type="hidden" id="ord_used_mileage2" /> <input
						type="hidden" id="ord_total2" /> <input name="ord_used_mileage"
						id="ord_used_mileage" type="text" value="0" size="10"
						oninput="chkMileage(this, '${member.member_mileage}')" />원
					&nbsp;(가용 적립금 : <span style="color: crimson; font-weight: bold">
						<fmt:formatNumber pattern="###,###,###"
							value="${member.member_mileage}" /> 원
					</span> <input type="checkbox" name="chkAll" id="chkAll"
						onclick="useAllMileage('${member.member_mileage}')">전부
					사용하기) <input type="button" value="사용"
						onclick="calcFinalSum(ord_used_mileage.value, '${map.finalSum}')" />
					<input type="button" value="취소"
						onclick="cancelMileage('${map.finalSum}')" />
					<p>적립금은 1,000원 이상일 경우 결제에 사용가능하며 주문 1건당 최대 가용 적립금은 10,000원입니다.</p>
					<p>배송비, 특가상품은 적립금 사용이 불가합니다.</p>
				</div>

				<!-- 추가: 한 세션에서 한 아이디로 두 번째 주문을 할 경우 적립금 금액 업데이트되는 메소드 구현해야 함 -->
			</div>
			<br>
			<div class="orderInfo">
				<div class="inputArea">
					<label for="ord_payment">결제수단</label> <input type="radio"
						name="ord_payment" id="ord_payment" value="카드결제" checked />카드결제 <input
						type="radio" name="ord_payment" id="ord_payment" value="카카오페이"
						disabled />카카오페이 <input type="radio" name="ord_payment"
						id="ord_payment" value="페이코" disabled />PAYCO <input type="radio"
						name="ord_payment" id="ord_payment" value="계좌이체" disabled />계좌이체 <br>
					<br>
					<br>
					<div id="cardInfo">
						<span id="cardCompany"> <select name="ord_card_info1"
							id="ord_card_info1">
								<option value="미래카드">미래카드</option>
								<option value="삼성카드">삼성카드</option>
								<option value="현대카드">현대카드</option>
								<option value="신한카드">신한카드</option>
								<option value="국민카드">국민카드</option>
						</select>
						</span> &nbsp;&nbsp;&nbsp;&nbsp;카드번호&nbsp;&nbsp; <input type="text"
							id="cardno1" maxlength="4" size="4" onkeypress="onlyNumber()" />
						<input type="password" id="cardno2" maxlength="4" size="4"
							onkeypress="onlyNumber()" /> <input type="password" id="cardno3"
							maxlength="4" size="4" onkeypress="onlyNumber()" /> <input
							type="text" id="cardno4" maxlength="4" size="4"
							onkeypress="onlyNumber()" /> &nbsp;&nbsp;CVC (카드 뒷면 3자리
						숫자)&nbsp;&nbsp; <input type="password" id="cardno5" maxlength="3"
							size="3" onkeypress="onlyNumber()" />

					</div>

				</div>
			</div>

			<!-- 이용약관 동의 -->
			<div class="orderInfo">
				<input type="checkbox" id="checkAllTerms" /> 하기 쇼핑몰 이용약관, 개인정보 처리방침에 모두
				동의합니다.
				<div class="inputArea">
					<input type="checkbox" id="checkTerms1" name="checkTerms" /> 전자상거래
					이용약관에 동의합니다. <br>
					<textarea id="term1" rows="15" cols="150" readonly>
 			<%@ include file="../include/terms1.jsp"%>
 			</textarea>
				</div>
				<div class="inputArea">
					<input type="checkbox" id="checkTerms2" name="checkTerms" />
					개인정보 처리방침에 동의합니다. <br>
					<textarea id="term1" rows="15" cols="150" readonly>
 			<%@ include file="../include/terms2.jsp"%>
 			</textarea>
				</div>
			</div>

			<button type="button" class="orderBtn" onclick="finalCheck()">결제하기</button>
			<button type="button" class="orderCancelBtn" onclick="orderCancel()">취소</button>


		</form>

	</section>

</body>
<%@ include file="../include/Footer.jsp"%>
</html>