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
//= require_tree .
//= require turbolinks


$(function() {
	
	$("#edit_payment_info_button").on("click", function(e) {
		$(".payment_info_first_part :input").attr("disabled", false);
		$(".payment_info_second_part :input").attr("disabled", true);
		return false;
	})
	
	$("#submit_order_button").on("click", function(e){ 
		var credit_card_number = $("input[name='payment_info[credit_card_number]']").val();
		var credit_card_cvv = $("input[name='payment_info[credit_card_cvv]']").val();
		var credit_card_exp_mm = $("select[name='payment_info[credit_card_exp_mm]']").val();
		var credit_card_exp_yyyy = $("select[name='payment_info[credit_card_exp_yyyy]']").val();
		
		var hidden_ccnumber_input = $("<input>").attr("type", "hidden").attr("name", "credit_card[credit_card_number]").val(credit_card_number);
		var hidden_cccvv_input = $("<input>").attr("type", "hidden").attr("name", "credit_card[credit_card_cvv]").val(credit_card_cvv);
		var hidden_ccexpmm_input = $("<input>").attr("type", "hidden").attr("name", "credit_card[credit_card_exp_mm]").val(credit_card_exp_mm);
		var hidden_ccexpyyyy_input = $("<input>").attr("type", "hidden").attr("name", "credit_card[credit_card_exp_yyyy]").val(credit_card_exp_yyyy);
		
		
		$(".credit_card_inputs").empty();
		$(".credit_card_inputs").append(hidden_ccnumber_input);
		$(".credit_card_inputs").append(hidden_cccvv_input);
		$(".credit_card_inputs").append(hidden_ccexpmm_input);
		$(".credit_card_inputs").append(hidden_ccexpyyyy_input);
	});
	
	$(".payment_info_second_part :input").attr("disabled", true);
	
	if (!$("#payment_info_create_an_account").is(":checked")) {
			$(".payment_info_password_fields").hide();
	}
	
	
	$("#payment_info_create_an_account").on("change", function(){ 
		if ($(this).is(":checked")) {
			$(".payment_info_password_fields").show();
		} else {
			$("#payment_info_password").val('');	
			$(".payment_info_password_fields").hide();
		}
	});

});