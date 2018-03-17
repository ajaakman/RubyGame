# Username and Password validation funcrion. 

function showBox(n)
{
    document.getElementById("boxDiv"+i).innerHTML="100";
    
    
}







function validateForm() {

    var x = document.forms["myForm"]["username"].value;
    var y = document.forms["myForm"]["password"].value;

    if (x == null || x == "" || y == null || y == "") {

        alert("Invalid Username or Password.");

        return false;
    }
} 