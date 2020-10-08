// Please excuse my rotation between JQuery and Regular JS.
// For some areas I find it easier to just do it the old way.
// Others, Referancing inside the DOM of JQuery is eaiser...
// Cry about it on the forums for me, k thnx.

var Character_ID = null
var Created = null
var Status = null
var Name = null
    
function CharacterSelected(id, name, time, status) {
    Character_ID = id;
    Name = String(name);
    Created = String(time);
    Status = String(status);
    CharInfoPanel();
};

function CharInfoPanel() {
    document.getElementById("name").innerHTML = Name;
    document.getElementById("created").innerHTML = Created;
    document.getElementById("status").innerHTML = Status;
};

function NewCheck() {
    if (Character_ID === 'New') {
        OpenNamer(true)
    }
};

function OpenOptions(bool) {
    if (bool) {
        var element = document.getElementById("Options");
        element.classList.remove("Hide");
        element.classList.add("Show");
    } else {
        var element = document.getElementById("Options");
        element.classList.remove("Show");
        element.classList.add("Hide");
    }
};

function OpenNamer(bool) {
    if (bool) {
        var element = document.getElementById("CharacterMake");
        element.classList.remove("Hide");
        element.classList.add("Show");
    } else {
        var element = document.getElementById("CharacterMake");
        element.classList.remove("Show");
        element.classList.add("Hide");
    }
};

function CharacterDelete() {
    $.post('https://core/CharactersDelete', JSON.stringify({
        ID: Character_ID,
    })
    );
    C.Display(false, "#CharacterList");
};

function CharacterJoin() {
    $.post('https://core/CharactersJoin', JSON.stringify({
        ID: Character_ID,
    })
    );
    C.Display(false, "#CharacterList");
};

function CharacterMake() {
    // Prevent form from submitting
    event.preventDefault(); 
    var fn = document.getElementById("FirstName").value;
    var ln = document.getElementById("LastName").value;
    var cm = document.getElementById("Height").value;
    var dob = document.getElementById("DateOfBirth").value;
    $.post('https://core/CharactersCreate', JSON.stringify({
        First_Name: fn,
        Last_Name: ln,
        Height: cm,
        Birth_Date: dob,
    })
    );
    OpenNamer(false);
};

(() => {
    C = {};

    C.Display = function (bool, div) {
        if (bool) {
            $(div).show();
        } else {
            $(div).hide();
        }
    };

    C.Characters = function (data) {
        if (data !== null) {
            $.each(data, function (index, char) {
                if (char.ID !== 0) {
                    $("#Row").prepend('<a id="' + char.Character_ID + '" class="Character tooltip" onclick="CharacterSelected(this.id,null,null,null); OpenOptions(true);"><img src="libraries/img/icons8-about-500.png"/><span class="tooltiptext">' + char.First_Name + ' ' + char.Last_Name + '</span></a>');
                }
            });
        }
    };

    C.Display(false, "#CharacterMake");
    C.Display(false, "#CharacterList");

    window.onload = function () {
        window.addEventListener("message", function (event) {
            var type = event.data.type;
            var char = event.data.char;
            switch (type) {
                case "CharacterSelect":
                    C.Display(true, "#CharacterList");
                    if (char !== null) {
                        C.Characters(char);
                    }
                    break;
            }
        });
    };

})();