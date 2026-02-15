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
                    <div class="rcontainer-content" id="container-${element.id}">
                        <div class="rcontainer-background"></div>
                        
                        <h2>${element.name}</h2>
                        <p>Mennyi container: ${element.count}</p>
                        <p>Küldetés nehézsége: ${element.difficulty}</p>
                        <p>Követelmény: ${element.xp}XP</p>

                        <button onclick="StartQuest(${element.id})">Küldetés felvétele</button>
                    </div>
                </div>
                `
        )
        $('.container-content').append($div)
    });
}

function StartQuest (id) {
    $.post('http://lynx_containerrobbery/StartQuest', JSON.stringify({
        id: id
    }),function (data) {
        if (data.success) {
            $(`#container-${id}`).text('Sikeresen elindítottad a küldetést!')
            setTimeout(() => {
                $(`#container-${id}`).text('Küldetés felvétele!')
                $('.container').fadeOut(400)
            }, 2000);
        } else {
            alert(data.message)
        }    
    })
}

$(window).on('keyup',function (e) {
    if (e.key === 'Escape') {
        $.post('http://lynx_containerrobbery/ClosePanel')
    }
})