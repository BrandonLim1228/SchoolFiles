% Ideal Flow Machine version 5.0 (Matlab). (c) William Devenport, October 2016
function IFM ()
global ui flow;
close all

flow.hString={'Enter strength & angle or f(z) and click on plot to set free stream flow',...
    'Enter strength and click on plot at source location',...
    'Enter strength and click on plot at vortex location',...
    'Enter strength & angle and click on plot at doublet location',...
    'Enter strength(s) and drag out source panel on plot',...
    'Enter strength(s) and drag out vortex panel on plot',...
    'Drag out circle on plot starting at center',...
    'Drag out circle on plot starting at center ending at Kutta condition point',...
    'Click on plot to draw streamline in flow direction, drag for rake',...
    'Click on plot to draw streamline against flow direction, drag for rake',...
    'Click on plot to draw equipotential to left of flow direction, drag for rake',...
    'Click on plot to draw equipotential to right of flow direction, drag for rake',};
flow.pString={'Strength & Angle, or f(z)','Strength','Strength','Strength & Angle','Strength (1 or 2 values)','Strength (1 or 2 values)','','','','','',''};
flow.types={'Free stream','Source','Vortex','Doublet','Source panel','Vortex panel','Circle','Circle with K.c.','Draw streamline+','Draw streamline-','Draw potential+','Draw potential-'};
flow.mapString={'','a,b','a,b','a,b','a,b','a,b','f(z)'};
flow.maps={'z','az^b','a(z+b/z)','a ln(z)-ib','a(exp(bz)+bz)','(z-a)/(az-1)+b','Custom'};
flow.map='';
flow.mapn=0;
flow.n=0; %number of elementary flows defined
flow.winf='0'; %free stream flow velocity (complex)
flow.ns=0; %number of streamlines defined
flow.MT=0; %1 or 2 (with Kutta condition) if MT circle present
flow.streamlineZ={};
flow.streamlineW={};
flow.mappedStreamlineZ={};
flow.mappedStreamlineW={};

ui.Figure=figure('WindowButtonMotionFcn', @mouseMove,'WindowButtonDownFcn', @clickIFM,'WindowButtonUpFcn', @mouseUp,'Units','normalized','Name','Ideal Flow Machine','NumberTitle','off');
ui.Axes=axes('position', [0.06    0.1500    0.88    0.750],'xgrid','on','ygrid','on','Box','on');
ui.circleZ=exp(i*[0:3:361]*pi/180);
ui.MTCircle=line(real(ui.circleZ)*0,imag(ui.circleZ)*0,'Parent',ui.Axes,'Marker','none','Color','g','Linestyle','-','Visible','off');
ui.MTKutta=line(0,0,'Parent',ui.Axes,'Marker','p','Color','g','Visible','off');
ui.streamline=[];ui.beingDrawn=0;ui.beingDrawnH=[];ui.flowH=[];ui.actionN=0;ui.actions=[];
ui.streamRake=line([0 1],[0 1],'Parent',ui.Axes,'Marker','.','Color','k','Linestyle','-.','Visible','off');
ui.rakeZ=[];
axis image;xlim([-8 8]);ylim([-4.9 4.9]);caxis([0 2]);hold on;
 
ui.fsAxes=axes('position',[.88 0.92 0.06 0.06],'Visible','off','Color',get(ui.Figure,'Color'));
fill(real(ui.circleZ),imag(ui.circleZ),'w');ylim([-1 1]);xlim([-1 1]);axis image;hold on;
set(ui.fsAxes,'Visible','off');
h=text(-2.5,0.0,'U_\infty');set(h,'Fontsize',8,'Fontangle','italic','Fontweight','normal');
ui.fsArrow=plot(ui.fsAxes,[0 0 0 0 0],[0 0 0 0 0],'b-');

flow.maxStep=1000;flow.streamStep=0.02;

ui.ChoiceBG=uicontrol(gcf,'Style','edit','Units','normalized','Position',[0.08 0.92 0.18 0.05],'String','');
ui.Choice=uicontrol(gcf,'Style','popupmenu','Units','normalized','Position',[0.08 0.92 0.18 0.05],'String',flow.types,'Callback',@selectFlow,'Tooltipstring',flow.hString{1});
ui.Parameter=uicontrol(gcf,'Style','edit','Units','normalized','Position',[0.27 0.92 0.16 0.05],'String','1,0','Tooltipstring',flow.pString{1});
ui.Undo=uicontrol(gcf,'Style','pushbutton','Units','normalized','Position',[0.44 0.92 0.12 0.05],'String','Undo','Callback',@undo,'Enable','Off');
ui.xLabel=uicontrol(gcf,'Style','edit','Units','normalized','Position',[0.57 0.92 0.12 0.05],'String','x=0','BackgroundColor','w','Horizontalalignment','left','enable','on');
ui.yLabel=uicontrol(gcf,'Style','edit','Units','normalized','Position',[0.7 0.92 0.12 0.05],'String','y=0','BackgroundColor','w','Horizontalalignment','left','enable','on');
ui.NewFlow=uicontrol(gcf,'Style','pushbutton','Units','normalized','Position',[0.56 0.03 0.12 0.05],'String','New Flow','Callback',@newFlow);
ui.saveFlow=uicontrol(gcf,'Style','pushbutton','Units','normalized','Position',[0.69 0.03 0.12 0.05],'String','Save Data','Callback',@saveFlow);
ui.ShowMap=uicontrol(gcf,'Style','pushbutton','Units','normalized','Position',[0.82 0.03 0.12 0.05],'String','Show Map','Callback',@createMapWindow);
ui.ZoomIn=uicontrol(gcf,'Style','pushbutton','Units','normalized','Position',[0.45 0.03 0.05 0.05],'String','+','Fontsize',12,'Callback',@zoom);
ui.ZoomOut=uicontrol(gcf,'Style','pushbutton','Units','normalized','Position',[0.5 0.03 0.05 0.05],'String',char(45),'Fontname','Symbol','Fontsize',12,'Callback',@zoom);

% Define colormaps
ui.blackMap=zeros([64 3]);
ui.Colormaps = {};
if exist('parula','file')
    maps={'parula'};
    colormap parula;
else
    maps={'jet'};
    colormap jet;
end
ui.colormapN=1;
ui.colormaps=[maps 'ui.blackMap','gray','hot','spring','pink','lines'];
ui.colorAxes=axes('position',[.14 0.03 0.24 0.05],'Xlim',[-1 1],'Ylim',[-1 1],'Color',get(ui.Figure,'Color'));
ui.colorbar=fill([-1 1 1 -1],[-1 -1 1 1],[0 1 1 0],'linestyle','none');
ui.colorText=text(0,0,ui.colormaps{1});set(ui.colorText,'Fontsize',8,'Fontangle','italic','Horizontalalignment','center','Color','w');
set(ui.colorAxes,'Visible','off');
axes(ui.Axes);

cl=caxis(ui.Axes);
ui.cLow=uicontrol(gcf,'Style','edit','Units','normalized','Position',[0.08 0.03 0.06 0.05],'String',num2str(cl(1)),'Callback',@colorRescale);
ui.cHigh=uicontrol(gcf,'Style','edit','Units','normalized','Position',[0.38 0.03 0.06 0.05],'String',num2str(cl(2)),'Callback',@colorRescale);

set(ui.Figure,'Toolbar','Figure');
end


function selectFlow (object, eventdata)
global ui flow

v=get(ui.Choice,'Value');
set(ui.Parameter,'Tooltipstring',flow.pString{v});
set(ui.Choice,'Tooltipstring', flow.hString{v});

if v==1 | v==4
    set(ui.Parameter,'String','1,0');
elseif v<=6
    set(ui.Parameter,'String','1');
else
    set(ui.Parameter,'String','');
end
end


function mouseMove (object, eventdata)
global ui mi flow

if object==ui.Figure
    axh=ui.Axes;xlh=ui.xLabel;ylh=ui.yLabel;
else
    axh=mi.Axes;xlh=mi.xLabel;ylh=mi.yLabel;
end
C=get(axh,'CurrentPoint');
x=C(1,1);y=C(1,2);
xl=get(axh,'xlim');yl=get(axh,'ylim');

mag=round(log10(xl(2)-xl(1)));fac=10^(3-mag);
if x>=xl(1) & x<=xl(2) & y>=yl(1) & y<=yl(2)
    set(object,'Pointer','crosshair');
    set(xlh,'String',['x = ' num2str(round(x*fac)/fac)]);
    set(ylh,'String',['y = ' num2str(round(y*fac)/fac)]);
else
    set(object,'Pointer','arrow');
end
    
if ui.beingDrawn && object==ui.Figure
    v=get(ui.Choice,'Value');
    if v>=5 && v<=6
        set(ui.beingDrawnH,'Xdata',[flow.tempX x],'Ydata',[flow.tempY y]);
    elseif v>=7 && v<=8 
        set(ui.MTCircle,'XData',real((ui.circleZ)*abs(x+i*y-flow.MTz)+flow.MTz),'YData',imag((ui.circleZ)*abs(x+i*y-flow.MTz)+flow.MTz));
        if v==8
            set(ui.MTKutta,'Xdata',x,'Ydata',y,'Visible','on');
        end
    elseif v>8
        set(ui.streamRake,'Xdata',[real(ui.rakeZ(1)) x],'Ydata',[imag(ui.rakeZ(1)) y]);
    end
end

end


function clickIFM (object, eventdata)
global ui mi flow;

set(ui.Figure,'Units','normalized');
clk=get(ui.Figure,'Currentpoint');
axp=get(ui.Axes,'Position');
axpc=get(ui.colorAxes,'Position');
axes(ui.Axes);
if (clk(1)>axp(1) && clk(1)<axp(1)+axp(3) && clk(2)>axp(2) && clk(2)<axp(2)+axp(4))  %If clicked on axes
    xs=get(ui.xLabel,'String');ys=get(ui.yLabel,'String');
	x=str2double(xs(4:end));
    y=str2double(ys(4:end));
    v=get(ui.Choice,'Value');
    if v==1
        clearStreamlines;
        parms=get(ui.Parameter,'String');
        test=str2num(parms);
        if length(test)==2
            flow.winf=[num2str(test(1)) '*exp(-i*' num2str(test(2)*pi/180) ')'];
        else
            try
                z=1.23454+2.12123*i;
                test1=eval([parms ';']);
                flow.winf=parms;
            catch
                flow.winf='0';set(ui.Parameter,'String',flow.winf);
            end
        end

        if ~strcmp(flow.winf,'0')
            ui.actions=[ui.actions(find(ui.actions~=1)) v];
            ui.actionN=length(ui.actions);set(ui.Undo,'Enable','on');
            if isempty(strfind(flow.winf,'z'))
                strength=abs(eval([flow.winf ';']));
                flowAngle=angle(eval([flow.winf ';']));
                if strength~=0
                    set(ui.fsArrow,'Xdata',.8*real(([-1 1 .75 .75 1]+i*[0 0 .15 -.15 0])*exp(-i*flowAngle)));
                    set(ui.fsArrow,'Ydata',.8*imag(([-1 1 .75 .75 1]+i*[0 0 .15 -.15 0])*exp(-i*flowAngle)));
                else
                    set(ui.fsArrow,'Xdata',[0 0 0 0 0]);
                    set(ui.fsArrow,'Ydata',[0 0 0 0 0]);
                end
            else
                set(ui.fsArrow,'Xdata',[-0.265625	-0.15625	-0.078125	0.03125	-0.109375	0.1875	0.03125	0.046875	0.078125	0.125	0.1875	0.25]);
                set(ui.fsArrow,'Ydata',[-0.47619	-0.460317	-0.349206	0.174603	0.174603	0.174603	0.174603	0.285714	0.365079	0.412698	0.428571	0.396825]);
            end
        else
            set(ui.fsArrow,'Xdata',[0 0 0 0 0]);
            set(ui.fsArrow,'Ydata',[0 0 0 0 0]);
        end
    elseif v>=2 & v<=4
        clearStreamlines;
        parms=get(ui.Parameter,'String');
        test=str2num(parms);
        if length(test)>0
            flow.n=flow.n+1;
            flow.type(flow.n)=v;
            flow.z(flow.n)=x+i*y;flow.z1(flow.n)=flow.z(flow.n);
            flow.param1(flow.n)=test(1);flow.param2(flow.n)=0;
            if length(test)>1
                flow.param2(flow.n)=test(2);
                if v==4
                    flow.param2(flow.n)=test(2)*pi/180;
                end
            end
            if v==2
                ui.flowH(flow.n)=line(x,y,'Parent',ui.Axes,'Marker','+','Linewidth',1,'Color','b');
            elseif v==3
                ui.flowH(flow.n)=line(x,y,'Parent',ui.Axes,'Marker','o','Linewidth',1,'Color','r');
            elseif v==4
                ui.flowH(flow.n)=line(x,y,'Parent',ui.Axes,'Marker','*','Linewidth',1,'Color','k');
            end
            ui.actionN=ui.actionN+1;ui.actions(ui.actionN)=v;set(ui.Undo,'Enable','on');
        end
    elseif v>=5 && v<=6
        clearStreamlines;
        parms=get(ui.Parameter,'String');
        test=str2num(parms);
        if length(test)==1 test(2)=test(1);end;
        if length(test)==2
            if ~ui.beingDrawn
                set(ui.Choice,'Enable','Off');set(ui.Parameter,'Enable','Off');
                set(ui.NewFlow,'Enable','Off');set(ui.saveFlow,'Enable','Off');
                set(ui.ShowMap,'Enable','Off');set(ui.Undo,'Enable','Off');
                flow.tempX=x;flow.tempY=y;
                ui.beingDrawn=1;
                if v==5
                    ui.beingDrawnH=line([flow.tempX x],[flow.tempY y],'Parent',ui.Axes,'Marker','none','Linestyle','-','Linewidth',1,'Color','b');
                else
                    ui.beingDrawnH=line([flow.tempX x],[flow.tempY y],'Parent',ui.Axes,'Marker','none','Linestyle','-','Linewidth',1,'Color','r');
                end
            end
        end
    elseif v>=7 && v<=8
        clearStreamlines;
        if ~ui.beingDrawn
            set(ui.Choice,'Enable','Off');set(ui.Parameter,'Enable','Off');
            set(ui.NewFlow,'Enable','Off');set(ui.saveFlow,'Enable','Off');
            set(ui.ShowMap,'Enable','Off');set(ui.Undo,'Enable','Off');
            ui.beingDrawn=1;
            flow.MTz=x+i*y;
            set(ui.MTCircle,'Xdata',real(ui.circleZ)*0+x,'Ydata',real(ui.circleZ)*0+y,'Visible','on');
            if v==7
                set(ui.MTKutta,'Visible','off');
            else
                set(ui.MTKutta,'Xdata',x,'Ydata',y,'Visible','on');
            end
        end
    elseif v>=9 && v<=12
        if flow.n>0 || ~strcmp(flow.winf,'0')
            if ~ui.beingDrawn
                set(ui.Choice,'Enable','Off');set(ui.Parameter,'Enable','Off');
                set(ui.NewFlow,'Enable','Off');set(ui.saveFlow,'Enable','Off');
                set(ui.ShowMap,'Enable','Off');set(ui.Undo,'Enable','Off');
                ui.beingDrawn=1;
                ui.rakeZ(1)=x+i*y;
                set(ui.streamRake,'Xdata',[x x],'Ydata',[y y],'Visible','on');
            end
        end
    end
elseif (clk(1)>axpc(1) && clk(1)<axpc(1)+axpc(3) && clk(2)>axpc(2) && clk(2)<axpc(2)+axpc(4)) %If clicked on colorbar
    ui.colormapN=ui.colormapN+1;
    if ui.colormapN>length(ui.colormaps)
        ui.colormapN=mod(ui.colormapN,length(ui.colormaps));
    end
    colormap(eval(ui.colormaps{ui.colormapN}));
    if ui.colormapN==2
        set(ui.colorText,'String','black');
    else
        set(ui.colorText,'String',ui.colormaps{ui.colormapN});
    end
end
end


function mouseUp (object, eventdata)
global ui mi flow

if ui.beingDrawn
    C=get(ui.Axes,'CurrentPoint');
    x=C(1,1);y=C(1,2);
    v=get(ui.Choice,'Value');
    parms=get(ui.Parameter,'String');
    test=str2num(parms);
    if length(test)==1 test(2)=test(1);end;
    if v==5 || v==6
        flow.n=flow.n+1;
        flow.type(flow.n)=v;
        flow.z(flow.n)=flow.tempX+i*flow.tempY;
        flow.z1(flow.n)=x+i*y;
        flow.param1(flow.n)=test(1);flow.param2(flow.n)=test(2);
        set(ui.Choice,'Enable','on');set(ui.Parameter,'Enable','on');
        set(ui.NewFlow,'Enable','on');set(ui.saveFlow,'Enable','on');
        set(ui.ShowMap,'Enable','on');set(ui.Undo,'Enable','on');
        ui.flowH(flow.n)=ui.beingDrawnH;
        ui.beingDrawn=0;ui.beingDrawnH=[];
        ui.actionN=ui.actionN+1;ui.actions(ui.actionN)=v;set(ui.Undo,'Enable','on');
    elseif v>=7 && v<=8
        flow.MTz1=x+i*y;
        if v==7
            flow.MT=1;
        else
            flow.MT=2;
        end
        set(ui.Choice,'Enable','on');set(ui.Parameter,'Enable','on');
        set(ui.NewFlow,'Enable','on');set(ui.saveFlow,'Enable','on');
        set(ui.ShowMap,'Enable','on');set(ui.Undo,'Enable','on');
        ui.beingDrawn=0;
        ui.actions=[ui.actions(find(ui.actions~=7 & ui.actions~=8)) v];
        ui.actionN=length(ui.actions);set(ui.Undo,'Enable','on');
    elseif v>8
        ui.rakeZ(2)=x+i*y;ui.beingDrawn=0;
        if v==9
            rf=1;mk='-';
        elseif v==10
            rf=-1;mk='-';
        elseif v==11
            rf=-i;mk=':';
        elseif v==12
            rf=i;mk=':';
        end
        if flow.MT==2
            flow.MTGamma=0;
            flow.MTGamma=2*pi*imag(velocityMT(flow.MTz1)*(flow.MTz1-flow.MTz));
        else
            flow.MTGamma=0;
        end      
        xl=get(ui.Axes,'xlim');
        ds=(xl(2)-xl(1))/25;
        s=abs(ui.rakeZ(2)-ui.rakeZ(1));
        nrake=floor(s/ds)+1;
        for ns=1:nrake
            z=ui.rakeZ(1)+(ui.rakeZ(2)-ui.rakeZ(1))*(ns-1)*ds/s;
            step=1;w=velocityMT(z)*rf;
            streamlineW(step)=w;streamlineZ(step)=z;
            while(step<flow.maxStep) 
                z1=z+conj(w)/abs(w)*flow.streamStep*(xl(2)-xl(1))/10;
                w1=velocityMT(z1)*rf;
                z=z+conj(w+w1)/abs(w+w1)*flow.streamStep*(xl(2)-xl(1))/10;
                w=velocityMT(z)*rf;step=step+1;
                streamlineW(step)=w;streamlineZ(step)=z;
            end
            x=real(streamlineZ);y=imag(streamlineZ);wm=abs(streamlineW);
            flow.ns=flow.ns+1;
            ui.streamline(flow.ns)=surface([x;x],[y;y],zeros(size([wm;wm])),[wm;wm],'Parent',ui.Axes,'Linestyle',mk,'facecol','no','edgecol','interp','linew',1);
            flow.streamlineZ{flow.ns}=streamlineZ;flow.streamlineW{flow.ns}=streamlineW;flow.StreamlineT(flow.ns)=rf;
            if ~strcmp(flow.map,'')
                [mz,mw]=mapStreamline(streamlineZ,streamlineW);
                mx=real(mz);my=imag(mz);mwm=abs(mw);
                mi.streamline(flow.ns)=surface([mx;mx],[my;my],zeros(size([mwm;mwm])),[mwm;mwm],'Parent',mi.Axes,'Linestyle',mk,'facecol','no','edgecol','interp','linew',1);
                flow.mappedStreamlineZ{flow.ns}=mz;
                flow.mappedStreamlineW{flow.ns}=mw;
            end
            drawnow;
        end
        set(ui.Choice,'Enable','on');set(ui.Parameter,'Enable','on');
        set(ui.NewFlow,'Enable','on');set(ui.saveFlow,'Enable','on');
        set(ui.ShowMap,'Enable','on');set(ui.Undo,'Enable','on');
        ui.actions(ui.actionN+1:ui.actionN+nrake)=v;ui.actionN=ui.actionN+nrake;set(ui.Undo,'Enable','on');
        set(ui.streamRake,'Visible','off');
    end
end
end



function undo (object, eventdata)
global ui mi flow;

if ui.actions(ui.actionN)==1
    flow.winf='0';
    set(ui.fsArrow,'Xdata',[0 0 0 0 0]);
    set(ui.fsArrow,'Ydata',[0 0 0 0 0]);
elseif ui.actions(ui.actionN)>=2 && ui.actions(ui.actionN)<=6
    delete(ui.flowH(flow.n));
    ui.flowH=ui.flowH(1:flow.n-1);
    flow.type=flow.type(1:flow.n-1);
    flow.z=flow.z(1:flow.n-1);
    flow.z1=flow.z(1:flow.n-1);
    flow.param1=flow.param1(1:flow.n-1);
    flow.param2=flow.param2(1:flow.n-1);
    flow.n=flow.n-1;
elseif ui.actions(ui.actionN)>=7 && ui.actions(ui.actionN)<=8
    disp('Hi')
    flow.MTz=0;
    flow.MTz1=0;
    flow.MT=0;
    set(ui.MTCircle,'Visible','off');
    set(ui.MTKutta,'Visible','off');
elseif ui.actions(ui.actionN)>=9 && ui.actions(ui.actionN)<=12
    delete(ui.streamline(flow.ns));
    flow.streamlineZ{flow.ns}=[];
    flow.streamlineW{flow.ns}=[];
    flow.streamlineT{flow.ns}=[];
    if ~strcmp(flow.map,'')
        delete(mi.streamline(flow.ns));
        flow.mappedStreamlineZ{flow.ns}=[];
        flow.mappedStreamlineW{flow.ns}=[];
    end
    flow.ns=flow.ns-1;
end
ui.actions=ui.actions(1:ui.actionN-1);
ui.actionN=ui.actionN-1;
if ui.actionN==0
    set(ui.Undo,'Enable','Off');
end
end


function colorRescale (object, eventdata)
global ui mi

if object==ui.cLow || object==ui.cHigh
    clh=ui.cLow;chh=ui.cHigh;axh=ui.Axes;
else
    clh=mi.cLow;chh=mi.cHigh;axh=mi.Axes;
end
cl=str2num(get(clh,'String'));ch=str2num(get(chh,'String'));

if ~isempty(cl) && ~isempty(ch)
    if cl(1)<ch(1)
        caxis(axh,[cl(1) ch(1)]);
        set(clh,'String',num2str(cl(1)));
        set(chh,'String',num2str(ch(1)));
        return;
    end
end

crange=caxis(axh);
set(clh,'String',num2str(crange(1)));
set(chh,'String',num2str(crange(2)));
end


function zoom (object, eventdata)
global ui mi

if object==ui.ZoomIn
    axh=ui.Axes;s=1;
elseif object==ui.ZoomOut
    axh=ui.Axes;s=-2;
elseif object==mi.ZoomIn
    axh=mi.Axes;s=1;
else
    axh=mi.Axes;s=-2;
end
C = xlim(axh);
range=C(2)-C(1);
xlim(axh,[C(1)+s*range/4 C(2)-s*range/4]);
C = ylim(axh);
range=C(2)-C(1);
ylim(axh,[C(1)+s*range/4 C(2)-s*range/4]);
end


function newFlow (object, eventdata)
global ui mi flow

cla(ui.Axes);
set(ui.fsArrow,'Xdata',[0 0 0 0 0]);
set(ui.fsArrow,'Ydata',[0 0 0 0 0]);
flow.n=0; %number of elementary flows defined
flow.winf=0; %free stream flow velocity (complex)
flow.ns=0; %number of streamlines defined
flow.type=[];
flow.winf='0';
flow.z=[];
flow.z1=[];
flow.param1=[];
flow.param2=[];
flow.streamlineZ={};
flow.streamlineW={};
ui.streamline=[];
flow.MTz=0;
flow.MTz1=0;
flow.MT=0;
ui.MTCircle=line(real(ui.circleZ)*0,imag(ui.circleZ)*0,'Parent',ui.Axes,'Marker','none','Color','g','Linestyle','-','Visible','off');
ui.MTKutta=line(0,0,'Parent',ui.Axes,'Marker','p','Color','g','Visible','off');
ui.streamRake=line([0 1],[0 1],'Parent',ui.Axes,'Marker','.','Color','k','Linestyle','-.','Visible','off');
ui.rakeZ=[];
ui.flowH=[];ui.actionN=0;ui.actions=[];set(ui.Undo,'Enable','Off');
try
    cla(mi.Axes);
    mi.streamline=[];
    set(mi.Hold,'Value',0);
    flow.mappedStreamlineZ={};
    flow.mappedStreamlineW={};
end
end


function saveFlow (object, eventdata)
global flow

[file,path]=uiputfile('*.mat','File for flow data');
save([path file],'flow');
end


function clearStreamlines()
global ui mi flow

for n=1:flow.ns
    delete(ui.streamline(n));
end
flow.streamlineZ={};
flow.streamlineW={};

ui.actions=ui.actions(find(ui.actions<=8));
ui.actionN=length(ui.actions);

try
    length(mi.streamline);
    if ~get(mi.Hold,'Value')
        cla(mi.Axes);    
    end
    mi.streamline=[];
catch
end
flow.mappedStreamlineZ={};
flow.mappedStreamlineW={};

flow.ns=0;
end


function w=velocityMT(z)
global flow

w=velocity(z);

if flow.MT
    r=abs(flow.MTz1-flow.MTz);
    mtr2=abs(z-flow.MTz)^2;
    mtz=flow.MTz+r^2*(z-flow.MTz)/mtr2;
    mtw=velocity(mtz);
    w=w-r^2/mtr2^2*conj(mtw)*conj(z-flow.MTz)^2;
    if flow.MT==2
        w=w-i*flow.MTGamma/2/pi/(z-flow.MTz);
    end
end
end


function w=velocity(z)
global flow

w=eval(flow.winf);
for n=1:flow.n
    if flow.type(n)==2
        w=w+flow.param1(n)/2/pi/(z-flow.z(n));
    elseif flow.type(n)==3
        w=w-i*flow.param1(n)/2/pi/(z-flow.z(n));
    elseif flow.type(n)==4
        w=w+flow.param1(n)*exp(i*flow.param2(n))/2/pi/(z-flow.z(n)).^2;
    elseif flow.type(n)==5
        q1=flow.param1(n);q2=flow.param2(n);z1=flow.z(n);z2=flow.z1(n);dzds=(z2-z1)/abs(z2-z1);
        w=w+q2*((z-z1)./(z2-z1).*log((z-z1)./(z-z2))-1)./dzds/2/pi-q1*((z-z2)./(z1-z2).*log((z-z2)./(z-z1))-1)./dzds/2/pi;
    elseif flow.type(n)==6
        q1=-i*flow.param1(n);q2=-i*flow.param2(n);z1=flow.z(n);z2=flow.z1(n);dzds=(z2-z1)/abs(z2-z1);
        w=w+q2*((z-z1)./(z2-z1).*log((z-z1)./(z-z2))-1)./dzds/2/pi-q1*((z-z2)./(z1-z2).*log((z-z2)./(z-z1))-1)./dzds/2/pi;
    end

end
end


function createMapWindow (object, eventdata)
global ui mi flow

try
    set(mi.Figure,'Visible','on');
    figure(mi.Figure);
catch
    mi.Figure=figure('WindowButtonMotionFcn', @mouseMove,'WindowButtonDownFcn', @clickMap,'CloseRequestFCn',@deleteMapWindow,'Units','normalized','Visible','on','Name','Mapped Plane','NumberTitle','off');
    mi.Axes=axes('position', [0.06    0.1500    0.88    0.750],'xgrid','on','ygrid','on','Box','on');
    axis image;xlim([-8 8]);ylim([-4.9 4.9]);caxis([0 2]);hold on;
    mi.ChoiceBG=uicontrol(gcf,'Style','edit','Units','normalized','Position',[0.08 0.92 0.18 0.05],'String','');
    mi.Choice=uicontrol(gcf,'Style','popupmenu','Units','normalized','Position',[0.08 0.92 0.18 0.05],'String',flow.maps,'Callback',@selectMap,'Tooltipstring','Select mapping function');
    mi.Parameter=uicontrol(gcf,'Style','edit','Units','normalized','Position',[0.27 0.92 0.20 0.05],'String','','Tooltipstring',flow.mapString{1});
    mi.xLabel=uicontrol(gcf,'Style','edit','Units','normalized','Position',[0.53 0.92 0.12 0.05],'String','x=0','BackgroundColor','w','Horizontalalignment','left','enable','on');
    mi.yLabel=uicontrol(gcf,'Style','edit','Units','normalized','Position',[0.66 0.92 0.12 0.05],'String','y=0','BackgroundColor','w','Horizontalalignment','left','enable','on');
    mi.Hold=uicontrol(gcf,'Style','togglebutton','Units','normalized','Position',[0.69 0.03 0.12 0.05],'String','Hold','Tooltipstring','Toggle to hold streamline pattern');
    mi.applyMap=uicontrol(gcf,'Style','pushbutton','Units','normalized','Position',[0.82 0.03 0.12 0.05],'String','Apply Map','Callback',@applyMap,'Tooltipstring','Press to apply mapping selected top left');
    mi.ZoomIn=uicontrol(gcf,'Style','pushbutton','Units','normalized','Position',[0.45 0.03 0.05 0.05],'String','+','Fontsize',12,'Callback',@zoom);
    mi.ZoomOut=uicontrol(gcf,'Style','pushbutton','Units','normalized','Position',[0.5 0.03 0.05 0.05],'String',char(45),'Fontname','Symbol','Fontsize',12,'Callback',@zoom);
    mi.streamline=[];
    flow.mapn=1;
    if exist('parula','file')
        colormap parula;
    else
        colormap jet;
    end
    mi.colorAxes=axes('position',[.14 0.03 0.24 0.05],'Xlim',[-1 1],'Ylim',[-1 1],'Color',get(mi.Figure,'Color'));
    mi.colorBar=fill([-1 1 1 -1],[-1 -1 1 1],[0 1 1 0],'linestyle','none');
    mi.colorText=text(0,0,ui.colormaps{1});set(mi.colorText,'Fontsize',8,'Fontangle','italic','Horizontalalignment','center','Color','w');
    set(mi.colorAxes,'Visible','off');
    cl=caxis(mi.Axes);mi.colormapN=1;
    mi.cLow=uicontrol(gcf,'Style','edit','Units','normalized','Position',[0.08 0.03 0.06 0.05],'String',num2str(cl(1)),'Callback',@colorRescale);
    mi.cHigh=uicontrol(gcf,'Style','edit','Units','normalized','Position',[0.38 0.03 0.06 0.05],'String',num2str(cl(2)),'Callback',@colorRescale);
    set(mi.Figure,'Toolbar','Figure');
end
end


function deleteMapWindow (object, eventdata)
global mi 

clear mi
flow.map='';
flow.mapn=0;
flow.mappedStreamlineZ={};
flow.mappedStreamlineW={};
delete(gcf)
end


function selectMap (object, eventdata)
global mi flow

v=get(mi.Choice,'Value');
set(mi.Parameter,'Tooltipstring',flow.mapString{v});

if v>=2 && v<=6
    set(mi.Parameter,'String','1,1');
else
    set(mi.Parameter,'String','');
end
end


function clickMap (object, eventdata)
global ui mi flow;

set(mi.Figure,'Units','normalized');
clk=get(mi.Figure,'Currentpoint');
axpc=get(mi.colorAxes,'Position');
if (clk(1)>axpc(1) && clk(1)<axpc(1)+axpc(3) && clk(2)>axpc(2) && clk(2)<axpc(2)+axpc(4)) %If clicked on colorbar
    mi.colormapN=mi.colormapN+1;
    if mi.colormapN>length(ui.colormaps)
        mi.colormapN=mod(mi.colormapN,length(ui.colormaps));
    end
    colormap(eval(ui.colormaps{mi.colormapN}));
    if mi.colormapN==2
        set(mi.colorText,'String','black');
    else
        set(mi.colorText,'String',ui.colormaps{mi.colormapN});
    end
end
end


function applyMap (object, eventdata)
global mi ui flow

v=get(mi.Choice,'Value');
parms=get(mi.Parameter,'String');
test=str2num(parms);

if v>=2 && v<=6 && length(test)<2
    questdlg('Invalid parameters','','Ok','Ok');
    return;
end

if v==1
    map='z';
elseif v==2
    map=[num2str(test(1)) '*z^' num2str(test(2))];
elseif v==3
    map=[num2str(test(1)) '*(z+' num2str(test(2)) '/z)'];
elseif v==4
    map=[num2str(test(1)) '*log(z)+i*' num2str(test(2))];
elseif v==5
    map=[num2str(test(1)) '*(exp(z*' num2str(test(2)) ')+' num2str(test(2)) '*z)'];
elseif v==6
    map=['(z-' num2str(test(1)) ')/(' num2str(test(1)) '*z-1)+' num2str(test(2)) '*z'];    
elseif v==7
    map=parms;
end

try
    z=1.23454+2.12123*i;test1=eval(map);
    z=1.33454-2.52173*i;test2=eval(map);
    if test1==test2
        flow.map='';
        questdlg('Invalid mapping','','Ok','Ok');
        return
    end
catch
    flow.map='';
    questdlg('Invalid mapping','','Ok','Ok');
    return
end

syms zeta(z);
eval(['zeta(z)=' map ';']);
flow.map=char(simplify(zeta));
flow.mderiv=char(simplify(diff(zeta)));

if ~get(mi.Hold,'Value')
    cla(mi.Axes);
end
flow.mappedStreamlineZ={};
flow.mappedStreamlineW={};
for n=1:flow.ns
    rf=flow.StreamlineT(n);
    if rf==i || rf==-i
        mk=':';
    else
        mk='-';
    end
    [mz,mw]=mapStreamline(flow.streamlineZ{n},flow.streamlineW{n});
    x=real(mz);y=imag(mz);wm=abs(mw);
    if ~get(mi.Hold,'Value')
        mi.streamline(n)=surface([x;x],[y;y],zeros(size([wm;wm])),[wm;wm],'Parent',mi.Axes,'Linestyle',mk,'facecol','no','edgecol','interp','linew',1);
    end
    flow.mappedStreamlineZ{n}=mz;
    flow.mappedStreamlineW{n}=mw;
end
end


function [mz,mw]=mapStreamline(sz,sw)
global ui mi flow

for n=1:length(sz)
    z=sz(n);
    mz(n)=eval(flow.map);
    mw(n)=sw(n)/eval(flow.mderiv);
end

end


