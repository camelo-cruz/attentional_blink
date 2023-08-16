function [rsvp, T1] = generateRSVPstream(t1, t1Pos, t2, t2Pos, fillers)

	streamLength = 18;

	rsvp = {};

	% if we want to play with the target set, we can do so here
    fillers = fileread(fillers);
    fillers = strsplit(fillers);

	for i = 1:streamLength
		rsvp(i) = fillers(randi(numel(fillers)));
    end


    rsvp(t1Pos) = t1(1);
    rsvp(t2Pos) = t2(1);

    rsvp = string(rsvp)

    T1 = t1;
