/* -----------------------------------------------------------------------------
 * variabile globale
 */
import 'Item.dart';
import 'REST.dart';


class G {
static int company=1;
static int branch=1000;
static int module=0;
static int refid=1234;
static String  user="Practica";
static String password="12345";
static int appid=1000;
static String logservice="login";
static String sqlservice="SqlData";
static String authsservice="authenticate";
static String backservice="setData";
static String srequest="PracticaSql";
static String Itedoc="ITEDOC";
static double min=0.0;
static double max=0.0;
static List groups=[];
static List CountryNames=[];
static List<Product> retval = [];
static IteDocA itedoca=IteDocA(3001, DateTime.now(), "Hello World");
static List<Item> item=[];
static IteDoc itedoc=IteDoc(itedoca, item);

}

