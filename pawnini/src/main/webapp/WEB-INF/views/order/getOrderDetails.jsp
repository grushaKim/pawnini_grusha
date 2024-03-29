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
<style>
.orderInfo {
	border: 5px solid #eee;
	padding: 10px 20px;
	margin: 20px 0;
}

.orderInfo span {
	font-size: 20px;
	font-weight: bold;
	display: inline-block;
	width: 90px;
}

.orderView li {
	margin-bottom: 20px;
	padding-bottom: 20px;
	border-bottom: 1px solid #999;
}

.orderView li::after {
	content: "";
	display: block;
	clear: both;
}

.thumb {
	float: left;
	width: 200px;
}

.thumb img {
	width: 200px;
	height: 200px;
}

.gdsInfo {
	float: right;
	width: calc(100% - 220px);
	line-height: 2;
}

.gdsInfo span {
	font-size: 20px;
	font-weight: bold;
	display: inline-block;
	width: 100px;
	margin-right: 10px;
}
</style>

</head>
<script>
	//주문 삭제(회원)
	function deleteOrder() {
		var ord_status = $("#ord_status").val();
		var ord_id = $("#ord_id").val();
		var member_id = $("#member_id").val();
		if (ord_status == "배송 준비 중") {
			swal({
				icon : "warning",
				text : "주문을 취소하시겠습니까?",
				buttons : [ "예", "아니오" ],
			}).then(function(isConfirm) {
				if (isConfirm) {
					window.location.reload();
				} else {
					$("#deleteOrderForm").submit();
					swal("", "주문이 취소되었습니다.", "success");
				}
			});
		} else {
			swal("", "이미 발송된 주문 건은 취소할 수 없습니다.", "error");
		}
	}
</script>
<%@ include file="../include/Header.jsp"%>
<body>

	<form id="deleteOrderForm" method="post" action="deleteOrder.do">
		<section id="content">
			<div class="orderInfo">
				<c:forEach items="${orderDetails}" var="orderDetails"
					varStatus="status">

					<c:if test="${status.first}">
						<input type="hidden" id="ord_id" name="ord_id"
							value="${orderDetails.ord_id}" />
						<input type="hidden" id="member_id" name="member_id"
							value="${orderDetails.member_id}" />
						<input type="hidden" id="ord_status" name="ord_status"
							value="${orderDetails.ord_status}" />
						<p>
							<span>주문번호</span>${orderDetails.ord_id}</p>
						<p>
							<span>주문일자</span>${orderDetails.ord_date}</p>
						<p>
							<span>주문현황</span>${orderDetails.ord_status}</p>
						<hr>
						<p>
							<span>결제수단</span>카드결제&nbsp;&nbsp;(${orderDetails.ord_card_info1})
						</p>
						<p>
							<span>최종결제금액</span>&nbsp;
							<fmt:formatNumber pattern="###,###,###"
								value="${orderDetails.ord_total}" />
							&nbsp;원&nbsp;
							<c:if test="${mileage != 0}">
    (사용한 적립금: <fmt:formatNumber pattern="#,###"
									value="${orderDetails.ord_used_mileage}" />&nbsp;원)
    </c:if>
						<hr>
						<p>
							<span>수령인명</span>${orderDetails.recipient_name}</p>
						<p>
							<span>배송지</span>(${orderDetails.ord_postcode})
							${orderDetails.ord_f_addr} ${orderDetails.ord_s_addr}
						</p>
						<p>
							<span>연락처</span>${orderDetails.ord_phone}</p>
						<p>
							<span>요청사항</span>${orderDetails.ord_req_msg}</p>
					</c:if>

				</c:forEach>

				<button type="button" id="deleteOrderBtn" onclick="deleteOrder()">주문
					취소</button>

				<p style="color: red; font-weight: bold;">※ 발송한 주문 건은 주문 취소가
					불가하오니 고객센터로 문의해 주시기 바랍니다.</p>
			</div>
			<ul class="orderView">
				<c:forEach items="${orderDetails}" var="orderDetails">
					<li>
						<div class="thumb">
							<img src="${orderDetails.product_thumb_img}" />
						</div>
						<div class="gdsInfo">
							<p>
								<span>상품명</span>${orderDetails.product_name}<br /> <span>판매가</span>
								<fmt:formatNumber pattern="###,###,###"
									value="${orderDetails.product_price}" />
								원<br /> <span>수량</span>${orderDetails.cart_amount} 개<br /> <span>합계</span>
								<fmt:formatNumber pattern="###,###,###"
									value="${orderDetails.product_price * orderDetails.cart_amount}" />
								원                 
							</p>
						</div>
					</li>
				</c:forEach>
			</ul>
		</section>
	</form>

</body>
<%@ include file="../include/Footer.jsp"%>
</html>