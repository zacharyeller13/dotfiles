glide.styles.add(css`
#sidebar-header {
  display: none;
}


/* Tab Numbers */
#tabbrowser-tabs{
  counter-reset: tab-counter 0;
}
.tabbrowser-tab .tab-content{padding-left: 2px;}
.tabbrowser-tab .tab-content::after{
    /* padding-left: 4px; */
    /* display: -moz-box; */
    z-index: -100;
    font-weight: bold;
    color: inherit;
    display: inline-block;
    background-color: #707070FF;
    text-align: center;
    width: 20px;
    height: 20px;
    line-height: 20px;
    border-radius: 20%;
    counter-increment: tab-counter;
    content: counter(tab-counter);
    margin-left: 3px;
    margin-right: 3px;
}

/* Floating url bar */
#urlbar:is([breakout][breakout-extend], [breakout][usertyping][focused]) {
    #urlbar-input {
        font-size: 16px !important;
    }

    z-index: 2;
    position: fixed !important;
    bottom: auto !important;
    top: 20vh !important;
    padding-left: 6px !important;
    padding-right: 8px !important;

    left: 18vw !important;
    right: 18vw !important;
    width: 64vw !important;

    &:after {
        content: "";
        position: fixed;
        pointer-events: none;

        width: 100vw;
        height: 100vh;

        top: 0px;
        left: 0px;

        background-color: rgba(0, 0, 0, 0.3);
        backdrop-filter: blur(5px);

        z-index: -1;
    }

    #identity-box {
        margin: auto 0;
        height: 30px;
        margin-right: 10px;
    }

    .urlbar-go-button {
        margin: auto 0;
    }
}
`)
