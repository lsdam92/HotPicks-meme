package com.kitri.hotpicks.contents.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping("/contents")
public class ContentsDetailController {
	
	@RequestMapping(value = "/contentdetail", method = RequestMethod.GET)
	public void contentdetail() {
//		System.out.println("상세일정들어옴");
//		return "/contents/contentdetail";
	}
}