$(document).ready(function () {
    $('#dob').live('focusout', function () {
        var dob_val = $(this).val();
        var dob_date = dob_val.split("-");
        var d = dob_date[0];
        var m = dob_date[1];
        var y = dob_date[2];
        var dob = new Date(y + '/' + m + '/' + d);

        var play_group_limit = '2017/9/30';
        var nursery_limit = '2016/9/30';
        var jr_kg_limit = '2015/9/30';
        var sr_kg_limit = '2014/9/30';
        var std_one_limit = '2013/9/30';
        var std_two_limit = '2013/1/31';

        var as_on_date = $(this).attr("as_on_date");

        var new_class = [];
        var current_class = [];
        if (dob != '') {

            if (dob <= new Date(play_group_limit)) {
                new_class = ['Play Group'];
            }
            if (dob <= new Date(nursery_limit)) {
                new_class = ['Play Group', 'Nursery'];
            }
            if (dob <= new Date(jr_kg_limit)) {
                new_class = ['Play Group', 'Nursery', 'Jr. Kg'];
            }
            if (dob <= new Date(sr_kg_limit)) {
                new_class = ['Play Group', 'Nursery', 'Jr. Kg', 'Sr. Kg'];
            }
            if (dob <= new Date(std_one_limit)) {
                new_class = ['Play Group', 'Nursery', 'Jr. Kg', 'Sr. Kg', 'I'];
            }
            if (dob <= new Date(std_two_limit)) {
                new_class = ['X', 'IX', 'VIII', 'VII', 'VI', 'V', 'IV', 'III', 'II'];
            }

            current_class = ['X', 'IX', 'VIII', 'VII', 'VI', 'V', 'IV', 'III', 'II', 'I', 'Sr. Kg', 'Jr. Kg', 'Nursery', 'Play Group'];

        }


        var new_data = new_class.reverse();
        var current_data = current_class.reverse();

        $('form input, form select').removeClass('inputTxtError');
        $('label.error').remove();
        $('#dob_error').removeClass().addClass('success');

        $('#class').html('');

        if (new_data.length === 0) {
            var msg = '<label class="error" for="dob">Invalid Date for admission</label>';
            $('input[name="dob"]').addClass('inputTxtError').after(msg);
            $('#dob_error').removeClass().addClass('error');
        } else {
            if (new_data.length != '9') {
                var msg = '<label class="error" for="dob">As per the Date of Birth your child is eligible for ' + new_data[0] + '</label>';
                $('input[name="dob"]').addClass('inputTxtError').after(msg);
            }/*else {
                      			if(dob <= new Date(std_one_limit) && dob >= new Date(std_two_limit)) {
                      				var msg = '<label class="error" for="dob">As per the Date of Birth your child is eligible for '+new_data[0]+'</label>';
                      				$('input[name="dob"]').addClass('inputTxtError').after(msg);
                      			}
                      		}*/
            $('#dob_error').removeClass().addClass('success');

            var class_html = '';
            if (new_data.length == '9') {
                class_html += '<option value="">Select Grade</option>';
            }
            $.each(new_data, function (i, v) {
                class_html += '<option value="' + v + '">' + v + '</option>';
            });

            var class_html_current = '';
            class_html_current += '<option value="">Select Grade</option>';
            $.each(current_data, function (i, v) {
                class_html_current += '<option value="' + v + '">' + v + '</option>';
            });

            $('#class').html(class_html);
            $('#currentclass').html(class_html_current);
        }

    });

});


