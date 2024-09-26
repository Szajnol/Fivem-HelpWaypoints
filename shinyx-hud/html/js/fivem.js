// ██╗░█████╗░░█████╗░███╗░░██╗██╗░█████╗░  ░██████╗░█████╗░██████╗░██╗██████╗░████████╗░██████╗
// ██║██╔══██╗██╔══██╗████╗░██║██║██╔══██╗  ██╔════╝██╔══██╗██╔══██╗██║██╔══██╗╚══██╔══╝██╔════╝
// ██║██║░░╚═╝██║░░██║██╔██╗██║██║██║░░╚═╝  ╚█████╗░██║░░╚═╝██████╔╝██║██████╔╝░░░██║░░░╚█████╗░
// ██║██║░░██╗██║░░██║██║╚████║██║██║░░██╗  ░╚═══██╗██║░░██╗██╔══██╗██║██╔═══╝░░░░██║░░░░╚═══██╗
// ██║╚█████╔╝╚█████╔╝██║░╚███║██║╚█████╔╝  ██████╔╝╚█████╔╝██║░░██║██║██║░░░░░░░░██║░░░██████╔╝
// ╚═╝░╚════╝░░╚════╝░╚═╝░░╚══╝╚═╝░╚════╝░  ╚═════╝░░╚════╝░╚═╝░░╚═╝╚═╝╚═╝░░░░░░░░╚═╝░░░╚═════╝░

Vue.component('hud-component', {
    data() {
        return {
            health: 0,
            hunger: 0,
            thirst: 0,
            voice: 0,
            talking: false,
            carHudVisible: true,
            hudVisible: true,
            speed: 0,
            engine: false,
            belt: false,
            fuel: 0,
            street: 'Strawberry Ave.',
            direction: 'S',
        };
    },
    methods: {
        updateStats(stat, data) {
            let percentage = data;
            let perimeter = 180 * 4; 
            let dashLength = (percentage / 100) * perimeter;
            let offset = perimeter / 2.6;
            
            $(`#${stat}`).attr('stroke-dasharray', `${dashLength} ${perimeter - dashLength}`);
            $(`#${stat}`).attr('stroke-dashoffset', offset);
        },
        getVoicePercentage(voice) {
            let percentage = 0;
            if (voice === 1.5) {
                percentage = 25;
            } else if (voice === 3) {
                percentage = 50;
            } else if (voice === 6) {
                percentage = 100;
            }
            return percentage;
        },
        toggleHud(toggle) {
            this.hudVisible = toggle;
            if (toggle) {
                $(".container").animate({ right: '1vw' }, 300);
            } else {
                $(".container").animate({ right: '-20vw' }, 300);
            }
        },
        toggleCarHud(toggle) {
            this.carHudVisible = toggle;
            if (toggle) {
                $(".carhud-container").animate({ bottom: '1.5vw' }, 300);
                $(".streetlabel").animate({ left: '2vw' }, 300);
            } else {
                $(".carhud-container").animate({ bottom: '-20vw' }, 300);
                $(".streetlabel").animate({ left: '-20vw' }, 300);
            }
        },
        updateCarhud(speed, engine, belt, fuel, street, direction) {
            this.speed = speed;
            this.engine = engine;
            this.belt = belt;
            this.fuel = fuel;
            this.street = street;
            this.direction = direction;
        },
        handleMessage(event) {
            let action = event.data.action;
  
            if (action === 'updateHud') {
                this.updateStats('healthx', event.data.health);
                this.updateStats('hungerx', event.data.hunger);
                this.updateStats('thirstx', event.data.thirst);
                this.updateStats('voicex', this.getVoicePercentage(event.data.voice));
                this.talking = event.data.talking;
                $('#voice').css('fill', this.talking ? '#6E25D9' : 'var(--voice)');
            } else if (action === 'toggleHud') {
                this.toggleHud(event.data.toggle);
            } else if (action === 'toggleCarhud') {
                this.toggleCarHud(event.data.toggle);
            } else if (action === 'updateCarhud') {
                this.updateCarhud(
                    event.data.speed,
                    event.data.engine,
                    event.data.belt,
                    event.data.fuel,
                    event.data.street,
                    event.data.direction
                );
            } else if (action === 'Notify') {
                this.createNotify(event.data.desc);
            }
        },
        createNotify(message) {
            const notifyHtml = `

            <div class="notify">
                <div class="data">
                    <i class="fa-light fa-circle-info"></i>
                    <div class="desc">${message}</div>
                </div>
                <div class="line">
                    <div class="progress"><div class="fill"></div></div>
                </div>
            </div>
        `;
        
        let $notify = $(notifyHtml);
        $('.notify-container').append($notify);
        
    
        $notify.animate({ right: '0vw' }, 300);
        setTimeout(function() {
            $notify.animate({ right: '-20vw' }, 300);
            setTimeout(function() {
                $notify.remove();
            }, 500);
        }, 5000);
        }
    },
    mounted() {
        window.addEventListener('message', this.handleMessage);
    },
    template: `
        <div>
            <div v-show="hudVisible" class="container">
                <svg id="svgSquare" viewBox="0 0 200 200" preserveAspectRatio="xMidYMid meet">
                    <rect id="healthx" x="10" y="10" width="180" height="180" fill="#060606" stroke="var(--health)" stroke-width="20" stroke-dasharray="0, 1000"></rect>
                    <text x="50%" y="52%" text-anchor="middle" dy=".3em" class="fa" id="health">&#xf004;</text>
                </svg>
                <svg id="svgSquare" viewBox="0 0 200 200" preserveAspectRatio="xMidYMid meet">
                    <rect id="hungerx" x="10" y="10" width="180" height="180" fill="#060606" stroke="var(--hunger)" stroke-width="20" stroke-dasharray="0, 1000"></rect>
                    <text x="50%" y="52%" text-anchor="middle" dy=".3em" class="fa" id="hunger">&#xf805;</text>
                </svg>
                <svg id="svgSquare" viewBox="0 0 200 200" preserveAspectRatio="xMidYMid meet">
                    <rect id="thirstx" x="10" y="10" width="180" height="180" fill="#060606" stroke="var(--thirst)" stroke-width="20" stroke-dasharray="0, 1000"></rect>
                    <text x="50%" y="52%" text-anchor="middle" dy=".3em" class="fa" id="thirst">&#xf869;</text>
                </svg>
                <svg id="svgSquare" viewBox="0 0 200 200" preserveAspectRatio="xMidYMid meet">
                    <rect id="voicex" x="10" y="10" width="180" height="180" fill="#060606" stroke="var(--voice)" stroke-width="20" stroke-dasharray="0, 1000"></rect>
                    <text x="50%" y="52%" text-anchor="middle" dy=".3em" class="fa" id="voice">&#xf6a8;</text>
                </svg>
            </div>
  
            <div v-show="carHudVisible" class="carhud-container">
                <div class="carhud">
                    <div class="variables">
                        <div class="x engine" :style="{ opacity: engine ? 1 : 0.5 }"><i class="fa-solid fa-engine"></i></div>
                        <div class="x belt" :style="{ opacity: belt ? 1 : 0.5 }"><i class="fa-solid fa-seat-airline"></i></div>
                    </div>
                    <div class="speed-data">
                        <div class="speed" >{{ speed }}</div>
                    </div>
                    <div class="type">KMH</div>
                </div>
                <svg id="svgSquare" class="fuel" viewBox="0 0 200 200" preserveAspectRatio="xMidYMid meet">
                    <rect id="fuelx" x="10" y="10" width="180" height="180" fill="#060606" stroke="var(--fuel)" stroke-width="15" stroke-dasharray="0, 1000"></rect>
                    <text x="50%" y="52%" text-anchor="middle" dy=".3em" class="fa" id="fuel">&#xf52f;</text>
                </svg>
            </div>
  
            <div class="streetlabel">
                <i class="fa-solid fa-map-location-dot"></i>
                <div class="street">{{ street }}</div> 
                <div class="direction x">{{ direction }}</div>
            </div>
            <div class="notify-container">

            </div>
        </div>

    `
});


  
new Vue({
    el: '#app'
});
