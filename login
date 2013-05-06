import java.awt.Component;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import javax.swing.BorderFactory;
import javax.swing.Box;
import javax.swing.BoxLayout;
import javax.swing.ButtonGroup;
import javax.swing.JButton;
import javax.swing.JCheckBox;
import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.JRadioButton;
import javax.swing.JScrollPane;
import javax.swing.JTextArea;
import javax.swing.ScrollPaneConstants;


@SuppressWarnings({ "unused", "serial" })
public class newframe
extends JFrame {

JCheckBox ckb;
JRadioButton radio;
static String[] pizzaToppings =
"Extra Cheese,Pepperoni,Sausage,Chicken,Meatball,Bacon,Ham,Beef,BBQChicken,Turkey".split(",");
static String[] pizzaSizes = "Small,Medium,Large".split(",");
static final String CLEAR = "clear";
static final String TOTAL = "total";
final ButtonGroup groupSizes = new ButtonGroup();
JPanel sizes, toppings;
JTextArea textArea;
static final private int[] PRICE_SIZES = {1000, 1200, 1700}; // pennies

public newframe() {
super("S.C. Pizza Maker");

JPanel options = makeOptionsPanel();
add(options);
setSize(400, 800);
setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
setLocationRelativeTo(null);
setVisible(true);
}

public static void main(String[] args) {
new newframe();

}

private JPanel makeOptionsPanel() {
JPanel p = new JPanel();
sizes = addRadioBoxes(pizzaSizes, "Pizza Sizes");
toppings = addCkBoxes(pizzaToppings, "Toppings");

p.setLayout(new BoxLayout(p, BoxLayout.Y_AXIS));
p.add(sizes);
// p.add(Box.createVerticalStrut(2));
p.add(toppings);

JPanel cmmdPanel = new JPanel();
cmmdPanel.setBorder(BorderFactory.createEmptyBorder(1, 10, 1, 10));
JButton clear = new JButton("Clr");
clear.setActionCommand(CLEAR);
clear.addActionListener(new MyButtonListener());
JButton total = new JButton("Total");
total.setActionCommand(TOTAL);
total.addActionListener(new MyButtonListener());
cmmdPanel.add(clear);
cmmdPanel.add(total);

p.add(cmmdPanel);
textArea = new JTextArea();
textArea.setRows(15);
JScrollPane sp = new JScrollPane( textArea );
sp.setHorizontalScrollBarPolicy(
ScrollPaneConstants.HORIZONTAL_SCROLLBAR_NEVER);
p.add( sp );

return p;
}

private void calcPrice() {
int total = 0;
double tip = 0;
Component c[] = sizes.getComponents();
JRadioButton r = (JRadioButton) c[0];
int priceIndex = 0;
for (int i = 0; i < c.length; i++) {

r = (JRadioButton) c[i];
if (r.isSelected()) {
priceIndex = i;
break;
}
}
textArea.setText("");
StringBuilder sb = new StringBuilder();
sb.append( String.format( "1 - %s Pizza with %n", pizzaSizes[priceIndex]));
total += PRICE_SIZES[priceIndex];

c = toppings.getComponents();
String accumTops = "";
JCheckBox ck;
for (int i = 0; i < c.length; i++) {
ck = (JCheckBox) c[i];
if (ck.isSelected()) {
accumTops += "" + i + ",";
}
}
if (!accumTops.isEmpty()) {
String[] orderedTops = accumTops.split(",");
for (int i = 0; i < orderedTops.length; i++) {
sb.append( String.format( " - %s%n", pizzaToppings[Integer.parseInt(orderedTops[i])]));
}
int subTotal = orderedTops.length > 2 ? (orderedTops.length - 1) * 50 : 0;
subTotal = subTotal > 450 ? 450 : subTotal;

total += subTotal;
tip = (total * 0.15)/100;

} else {
sb.append( String.format("%s%n", "<no extras") );
}
sb.append("======================\n");
sb.append( String.format("GRAND TOTAL: $%3d.%02d%n", total / 100, total % 100 ));
sb.append("Service tip: $" + tip);
textArea.setText( sb.toString() );
}

private JPanel addRadioBoxes(String[] opts, String title) {

int rows = opts.length;

JPanel p = new JPanel();
addBorder(p, title);
p.setLayout(new GridLayout(rows, 1));
for (int i = 0; i < rows; i++) {
p.add(radio = new JRadioButton(opts[i]));
groupSizes.add(radio);
}
Component[] c = p.getComponents();
radio = (JRadioButton) c[0];
radio.setSelected(true);

return p;
}

private void addBorder(JPanel p, String title) {
p.setBorder(
BorderFactory.createCompoundBorder(
BorderFactory.createEmptyBorder(6, 3, 6, 3),
BorderFactory.createTitledBorder(title)));
}

private JPanel addCkBoxes(String[] opts, String title) {

int rows = opts.length;

JPanel p = new JPanel();
addBorder(p, title);
p.setLayout(new GridLayout(rows, 1));
for (int i = 0; i < rows; i++) {
p.add(ckb = new JCheckBox(opts[i]));
}
return p;
}

private void clearButtons() {

Component[] c = sizes.getComponents();

JRadioButton r = (JRadioButton) c[0];
r.setSelected(true);

c = toppings.getComponents();
for (int i = 0; i < c.length; i++) {
JCheckBox ck = (JCheckBox) c[i];
ck.setSelected(false);
}
textArea.setText("");
}

class MyButtonListener implements ActionListener {

public void actionPerformed(ActionEvent e) {
if (e.getActionCommand().equals(CLEAR)) {
clearButtons();

} else if (e.getActionCommand().equals(TOTAL)) {
calcPrice();
}
}
}
}
