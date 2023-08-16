function [vpcode, vpnr] = getVpCode(exptstr)
%
% asks for subject-ID
%input: exptstr (string) name of experiment 
% by Martin Rolfs & Hans Arne Trukenbrod
% adapted for ptb3 by Jochen Laubrock

vpnr=NaN;
vpcode=NaN;
if nargin==1
	vpnr = inputdlg('Vp-Nummer')
	tmp=str2num(char(vpnr));
	if ~isempty(tmp)
		vpnr=tmp;
	else
		error('Valide Vp-Nummern muessen numerisch sein.')
	end
	if ~isstr(exptstr) | isempty(vpnr)
		vpcode = ['test' exptstr];
	else
		vpcode = [exptstr num2str(vpnr)];
	end
else
	fprintf(1, 'use 1 string argument during call to getVpCode\n');
	vpcode=NaN;
end

