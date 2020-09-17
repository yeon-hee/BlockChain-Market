package com.ecommerce.api;

import com.ecommerce.application.IBookmarkService;
import com.ecommerce.application.IRatingService;
import com.ecommerce.domain.Bookmark;
import com.ecommerce.domain.Rating;
import com.ecommerce.domain.exception.EmptyListException;
import io.swagger.annotations.ApiOperation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping("/api")
public class BookmarkController {
	public static final Logger logger = LoggerFactory.getLogger(BookmarkController.class);

	private IBookmarkService bookmarkService;

	@Autowired
	public BookmarkController(IBookmarkService bookmarkService) {
		Assert.notNull(bookmarkService, "bookmarkService 개체가 반드시 필요!");
		this.bookmarkService = bookmarkService;
	}

	@ApiOperation(value = "Register Bookmark")
	@RequestMapping(value = "/bookmarks", method = RequestMethod.POST)
	public long register(@RequestBody Bookmark bookmark) {
		return bookmarkService.register(bookmark);
	}

	@ApiOperation(value = "Fetch Bookmarks")
	@RequestMapping(value = "/bookmarks", method = RequestMethod.GET)
	public List<Bookmark> list() {
		List<Bookmark> list = bookmarkService.list();

		if (list == null || list.isEmpty())
			throw new EmptyListException("NO DATA");

		return list;
	}

	@ApiOperation(value = "Delete Bookmarks with id")
	@RequestMapping(value = "/bookmarks/{id}", method = RequestMethod.DELETE)
	public int delete(@PathVariable int id) {
		return bookmarkService.delete(id);
	}
}