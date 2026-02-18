let IsListRendered = false

window.addEventListener('message', function (event) {
    const e = event.data

    if (e.action === 'open') {        
        $('.container').fadeIn(400)

        $('#xp-value').text(e.xp)

        if (!IsListRendered) {
            RenderContainers(e.list)
            IsListRendered = true
        }
    } else if (e.action === 'close') {
        $('.container').fadeOut(400)
    } else if (e.action === 'resetbutton') {
        $(`#button-${e.id}`).text('Küldetés felvétele')
        $(`#button-${e.id}`).css('background-color', 'rgb(83, 83, 83)')
    }
})

function RenderContainers(list) {
    $('.container-content').empty()
    list.forEach(element => {
        $div = $(
            `<div class="rcontainer">
                    <div class="rcontainer-content" id="container-${element.id}">
                        <div class="rcontainer-background"></div>
                        
                        <h2>${element.name}</h2>
                        <p>Mennyi container: ${element.count}</p>
                        <p>Küldetés nehézsége: ${element.difficulty}</p>
                        <p>Követelmény: ${element.xp}XP</p>

                        <button onclick="StartQuest(${element.id})" id="button-${element.id}">Küldetés felvétele</button>
                    </div>
                </div>
                `
        )
        $('.container-content').append($div)
    });
}

function StartQuest(id) {
    console.log($(`#button-${id}`).text())
    if ($(`#button-${id}`).text() === 'Küldetés felvétele') {
        $.post(`https://${GetParentResourceName()}/StartQuest`, JSON.stringify({
            id: id
        }), function (data) {
            if (data.success) {
                text = 'Küldetés megszakítása'
                $(`#button-${id}`).text(text)
                $(`#button-${id}`).css('background-color', 'red')
            }
        })
    } else if ($(`#button-${id}`).text() === 'Küldetés megszakítása') {
        $.post(`https://${GetParentResourceName()}/BreakingQuest`, JSON.stringify({
            id:id
        }), function (data) {
            if (data.success) {
                text = 'Küldetés felvétele'
                $(`#button-${id}`).text(text)
                $(`#button-${id}`).css('background-color', 'rgb(83, 83, 83)')
            }
        })
    }
}

    $(window).on('keyup', function (e) {
        if (e.key === 'Escape') {
            $.post(`https://${GetParentResourceName()}/ClosePanel`)
        }
    })