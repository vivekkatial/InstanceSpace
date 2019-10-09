function h = drawGoodBadFootprint(Z, good, bad, Ybin, titlelabel)

orange = [1.0 0.6471 0.0];
blue = [0.0 0.0 1.0];
lbls = {'GOOD','BAD'};
h = zeros(1,2);
if any(~Ybin)
    drawFootprint(bad, orange, 0.2);
    h(2) = line(Z(~Ybin,1), Z(~Ybin,2), 'LineStyle', 'none', ...
                                        'Marker', '.', ...
                                        'Color', orange, ...
                                        'MarkerFaceColor', orange, ...
                                        'MarkerSize', 6);
end
if any(Ybin)
    drawFootprint(good, blue, 0.2);
    h(1) = line(Z(Ybin,1), Z(Ybin,2), 'LineStyle', 'none', ...
                                      'Marker', '.', ...
                                      'Color', blue, ...
                                      'MarkerFaceColor', blue, ...
                                      'MarkerSize', 6);
end
xlabel('z_{1}'); ylabel('z_{2}'); title([titlelabel ' Footprints']);
legend(h(h~=0), lbls(h~=0), 'Location', 'NorthEastOutside');
set(findall(gcf,'-property','FontSize'),'FontSize',12);
set(findall(gcf,'-property','LineWidth'),'LineWidth',1);
axis square;
end