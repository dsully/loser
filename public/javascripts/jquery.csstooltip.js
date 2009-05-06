/* jQuery plugin for easy CSS tooltips
 *
 * Based on Tooltip scripts by Alen Grakalic (http://cssglobe.com)
 * For more info visit http://cssglobe.com/post/1695/easiest-tooltip-and-image-preview-using-jquery
 *
 * Extended by Senko Rasic to call arbitrary function which builds tooltip HTML
 *
 * Example plugin usage cases:
 *
 * 1) put a normal tooltip on all anchors having 'tooltip' class, creating a
 *    paragraph with id 'tooltip' to hold the tooltip
 *    
 *      $('a.tooltip').tooltip(function (el) {
 *          return el.anchor_title;
 *      });
 *
 * 2) image preview (image + optional caption) on anchors having 'preview' class,
 *    creating a paragraph with id 'preview' to hold the tooltip
 *    
 *      $('a.preview').tooltip(function (el) {
 *              var c = (el.anchor_title != "") ? "<br/>" + el.anchor_title : "";
 *              return "<img src='"+ el.href +"' alt='image preview' />"+ c;
 *      }, {'tooltipID': 'preview'});
 *
 *
 * 3) url preview (image + optional caption) on anchors having 'screenshot' class,
 *    creating a paragraph with id 'screenshot' to hold the tooltip
 *    
 *      $('a.screenshot').tooltip(function (el) {
 *          var c = (el.anchor_title != "") ? "<br/>" + el.anchor_title : "";
 *         return "<img src='"+ el.rel +"' alt='url preview' />"+ c;
 *      }, {'tooltipID': 'screenshot'});
 */

(function($) {
    function tooltip(el, fn, options) {
        el.hover(function (e) {
            this.anchor_title = this.title;
            this.title = '';
            
            $('body').append('<p id="' + options.tooltipID + '">' + fn(this) + '</p>');
            $('#' + options.tooltipID)
                .css("top", (e.pageY - options.xOffset) + "px")
                .css("left", (e.pageX + options.yOffset) + "px")
                .fadeIn("fast");
        }, function () {
            this.title = this.anchor_title;
            $('#' + options.tooltipID).remove();
        });
        
        el.mousemove(function (e) {
            $('#' + options.tooltipID)
                    .css("top", (e.pageY - options.xOffset) + "px")
                    .css("left", (e.pageX + options.yOffset) + "px");
        });
    }

    $.fn.tooltip = function(fn, options) {
        options = options || {};
        var defaults = {
            xOffset: 10,
            yOffset: 20,
            tooltipID: 'tooltip'
        };        

        return this.each(function() {
            tooltip($(this), fn, $.extend(defaults, options));
        });
    }
    
})(jQuery);

