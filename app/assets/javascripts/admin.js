// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require jquery_nested_form
//= require jquery.ui.all
//= require turbolinks

$(document).on('keydown', '#new_shape_text_field', function(e) { 
	if (e.keyCode == 13) {
		var shape_name = $('#new_shape_text_field').val();
		$("#new_shape_text_field").remove();
		e.preventDefault();
		jQuery.ajax({
			url: "/admin/shapes",
			type: 'POST',
			data: {"shape": {"name": shape_name} },
			dataType: 'script'
		});
	}
});


$(document).on('click', '#new_shape_option', function(e) { 
	if (!document.querySelector("#new_shape_text_field")) {
		$(".shape_container").append("<input id='new_shape_text_field' name='shape[name]' type='text' placeholder='Enter a shape name'></input>");
	}
});

$(document).on('keydown', '#new_material_text_field', function(e) { 
	if (e.keyCode == 13) {
		var material_name = $('#new_material_text_field').val();
		$("#new_material_text_field").remove();
		e.preventDefault();
		jQuery.ajax({
			url: "/admin/materials",
			type: 'POST',
			data: {"material": {"name": material_name} },
			dataType: 'script'
		});
	}
});


$(document).on('click', '#new_material_option', function(e) { 
	if (!document.querySelector("#new_material_text_field")) {
		$(".material_container").append("<input id='new_material_text_field' name='material[name]' type='text' placeholder='Enter a material name'></input>");
	}
});

$(document).on('keydown', '#new_color_text_field', function(e) { 
	var colors_select = $(this).siblings(".colors");
	var index_of_select_dropdown = $(".colors").index(colors_select);
	
	if (e.keyCode == 13) {
		var color_name = $('#new_color_text_field').val();
		$("#new_color_text_field").remove();
		e.preventDefault();
		jQuery.ajax({
			url: "/admin/colors",
			type: 'POST',
			data: {"color": {"name": color_name}, "index": index_of_select_dropdown},
			dataType: 'script'
		});
	}
});


$(document).on('click', '#new_color_option', function(e) { 
	// if (!document.querySelector("#new_color_text_field")) {
		// $(".colors_container").append("<input id='new_color_text_field' name='color[name]' type='text' placeholder='Enter a color name'></input>");
		$(this).parent().after("<input id='new_color_text_field' name='color[name]' type='text' placeholder='Enter a color name'></input>");
	// }
});


$(document).on('keydown', '#new_vendor_text_field', function(e) { 
	if (e.keyCode == 13) {
		var vendor_name = $('#new_vendor_text_field').val();
		$("#new_vendor_text_field").remove();
		e.preventDefault();
		jQuery.ajax({
			url: "/admin/vendors",
			type: 'POST',
			data: {"vendor": {"name": vendor_name} },
			dataType: 'script'
		});
	}
});


$(document).on('click', '#new_vendor_option', function(e) { 
	if (!document.querySelector("#new_vendor_text_field")) {
		$(".vendor_container").append("<input id='new_vendor_text_field' name='vendor[name]' type='text' placeholder='Enter a vendor name'></input>");
	}
});

$(function() {
	
	$("#master_price").on("change keyup", function() {
		$(".variant_price").val($(this).val());
	});
	
	$('.sorted_product_mens_color_list').sortable({
		update: function( event, ui ) {
			var id_list = new Array();
		  $(".sorted_product_mens_color_list li").each(function(index){
				id_list[index] = $(this).attr("id");
			});
			jQuery.ajax({
				 url: '/admin/products_colors/update_mens_sort_order',
				 type: 'PUT',
				 data: {"new_order": id_list},
				 dataType: 'script'
			});
		}
	});
	
	$('.sorted_product_womens_color_list').sortable({
		update: function( event, ui ) {
			var id_list = new Array();
		  $(".sorted_product_womens_color_list li").each(function(index){
				id_list[index] = $(this).attr("id");
			});
			jQuery.ajax({
				 url: '/admin/products_colors/update_womens_sort_order',
				 type: 'PUT',
				 data: {"new_order": id_list},
				 dataType: 'script'
			});
		}
	});
	

	$('.sorted_product_image_list').sortable({
		update: function( event, ui ) {
			var id_list = new Array();
		  $(".sorted_product_image_list li").each(function(index){
				id_list[index] = $(this).attr("id");
			});
			jQuery.ajax({
				 url: '/admin/product_images/update_sort_order',
				 type: 'PUT',
				 data: {"new_order": id_list},
				 dataType: 'script'
			});
		}
	});
	

	$("#generate_variants_link").on("click", function(){
		
		var price = $("#price").val();
		
		var selected_sizes_and_measurements = {};
		$(".size_inputs").each(function(i, div){
		  var size = $(div).find(".sizes").val();
		  var measurements = $(div).find(".measurements").val();
			if (size) {
				selected_sizes_and_measurements[size] = measurements;
			}
		});
		
		var selected_sizes_and_weights = {};
		$(".size_inputs").each(function(i, div){
		  var size = $(div).find(".sizes").val();
		  var weight = $(div).find(".weight").val();
			if (size) {
				selected_sizes_and_weights[size] = weight;
			}
		});

		var selected_colors_and_genders = {};
		$(".color_inputs").each(function(i, div){
		  var color = $(div).find(".colors").val();
		  var genders = $(div).find("input:checkbox[name='gender[]']:checked").map(function(){return $(this).val();}).get();
			genders.push("none");
			if (color) {
				selected_colors_and_genders[color] = genders;
			}
		});
		

		jQuery.ajax({
			url: "/admin/products/generate_variants",
			type: 'GET',
			data: {"price": price, 
						"sizes_and_measurements": selected_sizes_and_measurements, 
						"colors_and_genders": selected_colors_and_genders,
						"sizes_and_weights": selected_sizes_and_weights
					},
			dataType: 'script'
		});

		return false;
	});
	
});