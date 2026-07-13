const sidebar = document.querySelector(".sidebar");
const sidebarBtn = document.querySelector(".sidebar-btn");



sidebarBtn.addEventListener("click", function(){
    sidebar.classList.toggle("active");
});

document.addEventListener("click", function(event) {
    if(!sidebar.contains(event.target) && !sidebarBtn.contains(event.target)){
        sidebar.classList.remove("active");
    }
});

document.addEventListener("scroll", function(event){
    if(sidebar.classList.contains("active")){
        sidebar.classList.remove("active");
    }
});