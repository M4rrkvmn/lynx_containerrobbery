window.addEventListener('message', function (event) {
    const e = event.data

    if (e.action === 'open') {
        RenderContainers(e.list)
        $('.container').fadeIn(400)
    } else if (e.action === 'close') {
        $('.container').fadeOut(400)
    }
})

function RenderContainers(list) {
    list.forEach(element => {
        $div = $(
            `<div class="rcontainer">
                    <div class="rcontainer-content">
                        <div class="rcontainer-background"></div>
                        
                        <h2>${element.name}</h2>
                        <p>Mennyi container: ${element.count}</p>
                        <p>Küldetés nehézsége: ${element.difficulty}</p>
                        <p>Követelmény: ${element.xp}XP</p>

                        <button>Küldetés felvétele</button>
                    </div>
                </div>
                `
        )
        $('.container-content').append($div)
    });
}