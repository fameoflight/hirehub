/*
 Class:    	Countdown
 Author:   	Hemant Verma [ Fameoflight ]
 */

jQuery.fn.time_from_seconds = function () {
    return this.each(function () {
        var t = parseInt($(this).text(), 10);
        $(this).data('original', t);
        var h = Math.floor(t / 3600);
        t %= 3600;
        var m = Math.floor(t / 60);
        var s = Math.floor(t % 60);
        $(this).text((h > 0 ? h + ' hour' + ((h > 1) ? 's ' : ' ') : '') +
            (m > 0 ? m + ' minute' + ((m > 1) ? 's ' : ' ') : '') +
            s + ' second' + ((s > 1) ? 's' : ''));
    });
};

function Countdown(options) {
    var timer,
        instance = this,
        seconds = options.seconds || 10,
        updateStatus = options.onUpdateStatus || function () {
        },
        counterEnd = options.onCounterEnd || function () {
        };

    function decrementCounter() {
        updateStatus(seconds);
        if (seconds === 0) {
            counterEnd();
            instance.stop();
        }
        seconds--;
    }

    this.start = function () {
        clearInterval(timer);
        timer = 0;
        seconds = options.seconds;
        timer = setInterval(decrementCounter, 1000);
    };

    this.stop = function () {
        clearInterval(timer);
    };
}
