function addKill(killer, weapon, killed, headshot) {
    let killfeedElement = `
        <div class="kill-wrapper">
            <div class="kill">
                <p class="red">${killer}</p>
                ${(weapon == "VEHICLE") ? `<i style="padding-left: 5px; padding-right: 5px;" class="fas fa-car-side"></i>` : `<img src="https://cdn.gtakoth.com/weapons/${weapon}.png">`}
                ${(headshot) ? '<i class="fas fa-crosshairs"></i> ' : ""}
                <p class="blue">${killed}</p>
            </div>
        </div>
    `;
    let elem = $(killfeedElement);
    $('.killfeed').append(elem);
    elem.hide().show(500);
    setTimeout(() => { elem.hide(500); setTimeout(() => { elem.html(""); }, 500); }, 5000);
}
  
// NUI Sended Event
window.addEventListener("message", function (event) {
    if (event.data.type == "newkill") {
        addKill(event.data.killer, event.data.weapon, event.data.killed, event.data.headshot);
    }
});