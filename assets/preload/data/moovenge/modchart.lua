function start (song)

end

function update (elapsed)
    local currentBeat = (songPos / 1000)*(bpm/60)
        for i=0,7 do
        setActorY(defaultStrum0Y + 15 * math.cos((currentBeat + i*0.25) * math.pi), i)
    end
end

function beatHit (beat)

end

function stepHit (step)

end

function keyPressed (key)

end