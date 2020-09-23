package com.ecommerce.domain;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class Item {
	private long id;
	private String name;
	private String category;
	private String explanation;
	private Boolean available = true;
	private long seller;
	private LocalDateTime registeredAt;
	private int image;
	private int price;
	private boolean directDeal;
	private String dealRegion;
	private int viewCount;

	@Override
	public String toString() {
		return "{ id: " + id + "\n\tname: " + name + "\n\texplanation: " + explanation + "\n\tavailable: " + available
				+ "\n\tseller: " + seller + "\n\tregisteredAt: " + registeredAt + "\n\timage: " + image + "\n\tprice: "
				+ price + "\n\tdirectDeal: " + directDeal + "\n\tdealRegion: " + dealRegion + " }";
	}
}
