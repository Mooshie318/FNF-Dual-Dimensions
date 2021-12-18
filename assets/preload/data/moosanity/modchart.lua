function start (song)

end

function update (elapsed)
    local currentBeat = (songPos / 1000)*(bpm/60)
        for i=0,7 do
        setActorY(defaultStrum0Y + 15 * math.cos((currentBeat + i*0.155) * math.pi), i)
    end
end

function beatHit (beat)

end

function stepHit (step)
    if step == 1916 then
        for i=0,3 do -- fade in opponent receptors
            tweenFadeOut(i,100,0.15)
        end
        for i=4,7 do -- fade out player receptors
            tweenFadeOut(i,0,0.15)
        end
    end
    if step == 1924 then
        for i=4,7 do -- fade in player receptors
            tweenFadeOut(i,100,0.15)
        end
        for i=0,3 do -- fade out opponent receptors
            tweenFadeOut(i,0,0.15)
        end
    end

    if step == 1932 then
        for i=0,3 do -- fade in opponent receptors
            tweenFadeOut(i,100,0.15)
        end
        for i=4,7 do -- fade out player receptors
            tweenFadeOut(i,0,0.15)
        end
    end
    if step == 1940 then
        for i=4,7 do -- fade in player receptors
            tweenFadeOut(i,100,0.15)
        end
        for i=0,3 do -- fade out opponent receptors
            tweenFadeOut(i,0,0.15)
        end
    end

    if step == 1948 then
        for i=0,3 do -- fade in opponent receptors
            tweenFadeOut(i,100,0.15)
        end
        for i=4,7 do -- fade out player receptors
            tweenFadeOut(i,0,0.15)
        end
    end
    if step == 1956 then
        for i=4,7 do -- fade in player receptors
            tweenFadeOut(i,100,0.15)
        end
        for i=0,3 do -- fade out opponent receptors
            tweenFadeOut(i,0,0.15)
        end
    end

    if step == 1964 then
        for i=0,3 do -- fade in opponent receptors
            tweenFadeOut(i,100,0.15)
        end
        for i=4,7 do -- fade out player receptors
            tweenFadeOut(i,0,0.15)
        end
    end
    if step == 1972 then
        for i=4,7 do -- fade in player receptors
            tweenFadeOut(i,100,0.15)
        end
        for i=0,3 do -- fade out opponent receptors
            tweenFadeOut(i,0,0.15)
        end
    end

    if step == 1980 then
        for i=0,3 do -- fade in opponent receptors
            tweenFadeOut(i,100,0.15)
        end
        for i=4,7 do -- fade out player receptors
            tweenFadeOut(i,0,0.15)
        end
    end
    if step == 1988 then
        for i=4,7 do -- fade in player receptors
            tweenFadeOut(i,100,0.15)
        end
        for i=0,3 do -- fade out opponent receptors
            tweenFadeOut(i,0,0.15)
        end
    end

    if step == 1996 then
        for i=0,3 do -- fade in opponent receptors
            tweenFadeOut(i,100,0.15)
        end
        for i=4,7 do -- fade out player receptors
            tweenFadeOut(i,0,0.15)
        end
    end
    if step == 2004 then
        for i=4,7 do -- fade in player receptors
            tweenFadeOut(i,100,0.15)
        end
        for i=0,3 do -- fade out opponent receptors
            tweenFadeOut(i,0,0.15)
        end
    end

    if step == 2012 then
        for i=0,3 do -- fade in opponent receptors
            tweenFadeOut(i,100,0.15)
        end
        for i=4,7 do -- fade out player receptors
            tweenFadeOut(i,0,0.15)
        end
    end
    if step == 2020 then
        for i=4,7 do -- fade in player receptors
            tweenFadeOut(i,100,0.15)
        end
        for i=0,3 do -- fade out opponent receptors
            tweenFadeOut(i,0,0.15)
        end
    end

    if step == 2028 then
        for i=0,3 do -- fade in opponent receptors
            tweenFadeOut(i,100,0.15)
        end
        for i=4,7 do -- fade out player receptors
            tweenFadeOut(i,0,0.15)
        end
    end
    if step == 2036 then
        for i=4,7 do -- fade in player receptors
            tweenFadeOut(i,100,0.15)
        end
        for i=0,3 do -- fade out opponent receptors
            tweenFadeOut(i,0,0.15)
        end
    end

    if step == 2048 then
        for i=0,3 do -- face in opponent receptors
            tweenFadeOut(i,100,0,3)
        end
    end
end

function keyPressed (key)

end