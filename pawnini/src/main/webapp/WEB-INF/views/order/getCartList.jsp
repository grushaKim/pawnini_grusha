<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="../style/getCartList.css" />
<script src="//code.jquery.com/jquery-3.3.1.min.js"></script>
<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
</head>
<script>
	$(document).ready(function() {

		//장바구니 목록 옵션 변경
		$("#cartForm").submit(function(e) {
			e.preventDefault();

			var formData = $("#cartForm").serialize();

			$.ajax({
				type : "post",
				url : "updateCart.do",
				data : formData,
				success : function(result) {
					swal("", "수량 변경 성공", "success");
					location.reload();
				},
			})
		});

		//주문서 이동
		$("#orderFormBtn").click(function() {
			location.href = "orderFormView.do";
		})

	});

	//장바구니 개별 아이템 삭제
	function deleteCart() {
		var confirmVal = confirm("해당 상품을 삭제하시겠습니까?");

		if (confirmVal) {

			var cart_id = $("#cart_id").val();

			$.ajax({
				url : "deleteCart.do",
				type : "post",
				data : {
					cart_id : cart_id
				},
				success : function() {
					location.reload();
				},
			});
		}
	}
</script>
<%@ include file="../include/Header.jsp"%>
<body>

	<a href="main.do">메인으로 가기</a>



	<c:choose>
		<c:when test="${map.count == 0}">
		장바구니에 상품을 추가해 주시기 바랍니다.
	</c:when>
		<c:otherwise>
			<form name="cartForm" id="cartForm">
				<table border="1">
					<tr>
						<th></th>
						<th>상품명</th>
						<th>판매가</th>
						<th>수량</th>
						<th>합계</th>
						<th></th>
						<c:forEach var="row" items="${map.cartList}" varStatus="i">
							<tr>
								<td><img style="width: 100px; height: 150px;"
									src="${row.product_thumb_img}" />
								<td>${row.product_name}
								<td style="width: 80px" align="right"><fmt:formatNumber
										pattern="###,###,###" value="${row.product_price}" />&nbsp;원
								
								<td><input type="number" id="cart_amount"
									style="width: 40px" name="cart_amount"
									value="${row.cart_amount}" />
									<button type="submit" id="updateCartBtn">수정</button> <input
									type="hidden" id="product_id" name="product_id"
									value="${row.product_id}" /> <input type="hidden" id="cart_id"
									name="cart_id" value="${row.cart_id}" /> <input type="hidden"
									id="member_id" name="member_id" value="${member.member_id}" />
								<td style="width: 100px" align="right">
									<!-- 아이템당 수량 *가격  = cart_total--> <fmt:formatNumber
										pattern="###,###,###" value="${row.cart_total}" />&nbsp;원
								<td>
									<button type="button" id="deleteBtn" onclick="deleteCart()">삭제</button>
						</c:forEach>
					<tr>
						<td colspan="6" align="right">상품 주문 금액: <fmt:formatNumber
								pattern="###,###,###" value="${map.sumTotal}" />&nbsp;원<br>
							배송비: <fmt:formatNumber pattern="###,###,###"
								value="${map.shippingFee}" />&nbsp;원<br> 최종 주문 금액: <fmt:formatNumber
								pattern="###,###,###" value="${map.finalSum}" />&nbsp;원
				</table>
				<input type="hidden" name="count" value="${map.count}" />
			</form>
		</c:otherwise>
	</c:choose>
	<hr>
	<div>
		<button type="submit" id="orderFormBtn">주문하러 가기</button>
	</div>


</body>
<%@ include file="../include/Footer.jsp"%>
</html>