function [rsvp, T1, T2] = generateRSVPstream(t1, t1Pos, t2, t2Pos, fillers)

	streamLength = 18;

	rsvp = {};

    fillers = fileread(fillers);
    fillers = strsplit(fillers);

	for i = 1:streamLength
		rsvp(i) = fillers(randi(numel(fillers)));
    end


    rsvp(t1Pos) = t1(1);
    rsvp(t2Pos) = t2(1);

    rsvp = string(rsvp);

    T1 = t1{1};
    T2 = t2{1};
