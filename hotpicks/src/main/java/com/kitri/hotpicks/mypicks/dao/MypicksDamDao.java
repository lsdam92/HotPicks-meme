package com.kitri.hotpicks.mypicks.dao;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;


import com.kitri.hotpicks.mypicks.model.PickListDto;

public interface MypicksDamDao {

	// 글 목록 
			List<PickListDto> listArticle(Map<String, String> map);
			
	// 글 수정 | 
			void modifyArticle(Map<String, Object> map);

	// 글 삭제 | 
			void deleteArticle(Map<String, ArrayList<String>> map);
	//달력
			List<PickListDto> calArticle(Map<String, String> map);
			
}
