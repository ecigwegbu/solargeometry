// Get all tab elements
const tabs = document.querySelectorAll(".tab");

// Add click event listener to each tab
tabs.forEach((tab) => {
  tab.addEventListener("click", () => {
    // Remove active class from all tabs
    tabs.forEach((tab) => tab.classList.remove("active"));
    alert(tab.classList.entries(0));

    // Add active class to the clicked tab
    tab.classList.add("active");

    // Get the content linked to the tab
    const target = document.querySelector(tab.dataset.target);

    // Hide all tab contents
    const tabContents = document.querySelectorAll(".tab-content");
    tabContents.forEach((content) => (content.style.display = "none"));

    // Show the content linked to the clicked tab
    target.style.display = "block";
  });
  alert("In function");
});
