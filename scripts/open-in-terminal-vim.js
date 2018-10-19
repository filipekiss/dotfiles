function run(input, parameters) {
    var iTerm = Application('iTerm2');
    iTerm.activate();
    var windows = iTerm.windows();
    var window;
    var tab;
    if (windows.length) {
        window = iTerm.currentWindow();
        tab = window.currentTab();
    } else {
        window = iTerm.createWindowWithDefaultProfile();
        tab = window.currentTab();
    }
    var session = tab.currentSession();
    var files = [];
    for (var i = 0; i < input.length; i++) {
        files.push(quotedForm(input[i]));
    }
    session.write({text: ':e ' + files.join(' ')});
}

function quotedForm(path) {
    var string = path.toString();
    return string.replace(' ', '\\ ');
}
