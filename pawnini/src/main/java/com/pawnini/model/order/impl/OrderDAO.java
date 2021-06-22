package com.pawnini.model.order.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.pawnini.model.order.CartDTO;
import com.pawnini.model.order.OrderDTO;
import com.pawnini.model.order.OrderDetailsDTO;
import com.pawnini.model.order.OrderListDTO;

@Repository
public class OrderDAO {
	
	@Autowired
	private SqlSessionTemplate mybatis;
	
	//주문 정보 삽입
	public void insertOrder(OrderDTO dto) throws Exception{
		System.out.println("Mybatis/insertOrder() 기능처리 시작");
		mybatis.insert("OrderDAO.insertOrder", dto);
	}
	
	//상세주문 정보 삽입
	public void insertOrderDetails(OrderDetailsDTO dtoList) throws Exception{
		System.out.println("Mybatis/insertOrderDetails() 기능처리 시작");
		mybatis.insert("OrderDAO.insertOrderDetails", dtoList);
	}
	
	//특정 ID 주문 정보 불러오기
	public List<OrderDTO> getOrderList(OrderDTO dto) throws Exception{
		System.out.println("Mybatis/getOrderList() 기능처리 시작");
		return mybatis.selectList("OrderDAO.getOrderList", dto);
	}
	
	//상세주문 보기
	public List<OrderListDTO> getOrderDetails(OrderDTO dto) throws Exception{
		System.out.println("Mybatis/getOrderDetails() 기능처리 시작");
		return mybatis.selectList("OrderDAO.getOrderDetails", dto);
	}
	
	//장바구니 제품 추가
	public void addToCart(CartDTO dto) throws Exception{
		System.out.println("Mybatis/addToCart() 기능처리 시작");
		mybatis.insert("OrderDAO.addToCart", dto);
	}
	
	//장바구니 목록 불러오기
	public List<CartDTO> getCartList(String member_id) throws Exception{
		System.out.println("Mybatis/getCartList() 기능처리 시작");
		return mybatis.selectList("OrderDAO.getCartList", member_id);
	}
	
	//장바구니 수량 수정
	public void modifyCart(CartDTO dto) throws Exception{
		System.out.println("Mybatis/modifyCart() 기능처리 시작");
		mybatis.update("OrderDAO.modifyCart", dto);
		System.out.println("Mybatis/modifyCart() 기능처리 완료");
	}
	
	//장바구니 중복 제품 확인
	public int countCart(int product_id, String member_id) throws Exception{
		System.out.println("Mybatis/countCart() 기능처리 시작");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("product_id", product_id);
		map.put("member_id", member_id);
		
		System.out.println("Mybatis/dcountCart() 기능처리 완료");
		
		return mybatis.selectOne("OrderDAO.countCart", map);
	}
	
	//장바구니 중복 제품 수량 합치기
	public void checkOverlap(CartDTO dto) throws Exception{
		System.out.println("Mybatis/checkOverlap() 기능처리 시작");
		mybatis.update("OrderDAO.checkOverlap", dto);
	}
	
	//장바구니 ID 삭제
	public void deleteCartId(int cart_id) throws Exception {
		System.out.println("Mybatis/deleteCartId() 기능처리 시작");
		mybatis.delete("OrderDAO.deleteCartId", cart_id);
		System.out.println("Mybatis/deleteCartId() 기능처리 완료");
	}
	
	//특정 회원 장바구니 삭제
	public void deleteCartByMember(String member_id) throws Exception{
		System.out.println("Mybatis/deleteCartByMember() 기능처리 시작");
		mybatis.delete("OrderDAO.deleteCartByMember", member_id);
	}
		
	
	//장바구니 금액 합계 구하기
	public int getSum(String member_id) throws Exception{
		System.out.println("Mybatis/getSum() 기능처리 시작");
		return mybatis.selectOne("OrderDAO.getSum", member_id);
	}

}