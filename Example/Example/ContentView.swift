//
//  ContentView.swift
//  Example
//
//  Created by Philip Niedertscheider on 17.06.21.
//

import SwiftUI
import CoolDownParser
import CoolDownSwiftUIMapper

struct ContentView: View {

    let text = """
    # Nahrungsergänzungen

    ## BCAAS

    Die drei verzweigten Aminosäureketten L-Leucin, L-Isoleucin und L-Valin sind eher unter ihrer englischen Abkürzung bekannt: BCAA (Branched Chain Amino Acids).

    Dis sind essentielle Aminosäuren, die vor allem eine wichtige Rolle im Protein-, Energie- und Stressstoffwechsel spielen.

    Benefits:

    - Immunsystem
    - Regeneration
    - Gehirnfunktion
    - Muskelaufbau
    - Energie Produktion

    **Dosierung: 3000-5000 mg/Tag**

    ### Immunsystem

    BCAA sind unbedingt für die gute Funktion des Immunsystems notwendig. Ein Mangel an BCAA hemmt verschiedene Aspekte des Immunsystems. Daneben sind BCAA Baustoffe der flexiblen Seite der Antikörper; Substanzen, die den humoralen Teil des Immunsystems bilden.

    ### Insulinproduktion

    BCAA regulieren die Insulinproduktion, was wiederum die Aufnahme von Aminosäuren durch das Muskelgewebe unterstützt und den Abbau von Muskelgewebe verzögert.
    Daneben greif Leucin günstig auf den Wirkungsmechanismus von Insulin und den Gebrauch von Glukose.

    ### Gehirn

    BCAA spielen auf verschiedene Weise eine Rolle in der Biochemie des Gehirns. Sie beschleunigen den Denkvorgang im Hirn und somit steigert es die Leistungsfähigkeit. Unteranderem unterstützt es die Aufnahme andere wichtigen Aminosäuren bei deren Mangel erhebliche Schäden auftreten können.

    ### Regeneration

    Regeneration nach Operation: Logischerweise sind BCAA auch während der Regenerationsphase nach Operationen wichtig. In diesem Zeitraum muss viel neues Gewebe produziert werden.

    ## L-Arginin

    Mit zunehmendem Alter vermindert sich die Bildung von Wachstumhormon durch die Hypophyse. Dadurch geht die Regenerationsfähigkeit (zum Beispiel von Bindegewebe, Muskeln,. Knochen und bei der Wundheilung) immer weiter zurück. Gleichzeitig verliert dadurch auch das Immunsystem einen wichtigen Impuls.

    Benefits:

    - Muskelaufbau
    - Wachstumhormon
    - Fettansammlungen am Bauch
    - Faltenbildung
    - Gedächtnisstörungen

    **Dosierung: 1000-3000 mg/Tag**

    ## Magnesium

    Ein Magnesiummangel wirkt sich negativ auf das Magen-Darm-System, das Herz, die Muskeln, das Skelett und das zentrale Nervensystem aus. Ein Magnesiummangel äußert sich häufig durch Muskelkrämpfe und Müdigkeit.

    Benefits:

    - Energie für Stoffwechsel
    - Knochendichte
    - Gegen Müdigkeit
    - Konzentration
    - Blutdruck
    - Krämpfe

    **Dosierung: 300-350 mg/Tag**

    ### Blutdruck
    Magnesium hat einen Einfluss auf den Blutdruck, es trägt bei dem Bluthochdruck entgegen zu wirken. Erweiterung und Engstellung der Blutgefäße dienen der Regulierung der Durchblutung der Organe und Gewebe im Körper.

    ### Mental

    Im Gehirn unterstütz Magnesium kognitive Funktionen wie Gedächtnis und Konzentrationsvermögen. Die angsthemmende Wirkung des Magnesiums hängt zum Teil mit seiner entspannenden Wirkung auf die Muskulatur und seiner regulierenden Wirkung auf Neurotransmitter zusammen.

    ### Migräne

    Forscher haben niedrige Magnesiumspiegel im Liquor mit Migräne in Verbindung gebracht. Migräne-Kopfschmerzen sind das Ergebnis einer Cortical Spreading Depression (CSD). Dies könnte der Grund sein, warum Patienten mit erhöht reizbaren Nerven anfälliger für Migräneattacken sind.

    ### Lungenfunktion

    Da Magnesium zur Muskelzellenentspannung beitragen kann und entzündungshemmende Eigeschaften hat, kann erwartet werden, dass Magnesium bei der Behandlung von Asthma wirksam ist. Magnesium reduziert Bronchospasmen und bronchiale Reaktivität.

    ## Omega 3

    Omega-3- und Omega-6-Fettsäuren sind mehrfach ungesättigte Fettsäuren. Gerade bei der Regulierung von Entzündungsreaktionen spielen die mehrfach ungesättigten Fettsäuren eine wichtige Rolle bei verschiedenen entzündlichen Erkrankungen der Gelenke, der Haut, der Atemwege, des Darm und des zentralen Nervensystems.

    Benefits:

    - Haut, Haare, Nägel
    - Gehirnfunktion
    - Sehkraft
    - Herz-.Kreislauf-Erkrankungen
    - Gelenke
    - Darm
    - Fruchtbarkeit

    **Dosierung: 250-500 mg EPA-DHA/Tag**

    ### Gelenke

    Intervention mit Muscheln verbesserte den allgemeinen Gesundheitszustand, die Krankheitsaktivität, die Müdigkeit und den Grad der Schmerzen bei Patienten. Zum Beispiel zeigt eine Studie einen signifikant positiven Effekt auf Morgensteifigkeit und schmerzende Gelenke durch die Supplementierung von Fisch und Fischöl.

    ### Haut

    Eine Ernährung, die reich an Omega-3-Fettsäuren ist, unterstützt deine Haut optimal. Sie ist besser vor dem Austrocknen geschützt. Sie regeneriert sich wirksamer und altert weniger schnell. Entzündliche Hautzustände können gemildert werden.

    ### Darm

    Die Omega-3s EPA und DHA die sich in Fisch und Meeresfrüchten und in Fischöl befinden, können Entzündungen reduzieren und die Anzahl nützlicher Mikroorganismen erhöhen, die einen Schutz gegen Magen-Darm-Erkrankungen bieten.

    ### Gehirn

    Ein Mangel an Omega-3 während der fötalen Entwicklung und der frühen Kindheit kann negative Auswirkungen auf die Gehirn- und neurologische Entwicklung haben. Ein Mangel während der neuronalen Entwicklung kann zu schweren Erkrankungen wie Schizophrenie und (ADHS) führen.

    # Unsere Favoriten

    ## Omega 3

    Das optimal Anti-Aging Produkt:
    Mehrfach ungesättigte Fettsäuren werden vom Körper nicht selbst aufgebaut — müssen also zugeführt werden. Für Forever Arctic Sea® werden nur hochgereinigte essentielle Omega-3-Fettsäuren aus Hochseefischen sowie Calamari verwendet. Zusätzlich versetzt mit Zitronen- und Limettenöl für eine frische Note und beste Verdaulichkeit.

    ![Forever Arctic Sea](https://storage.kula.app/assets/public/0137F82B-2654-4549-83A0-54CAF9B87F70/original.jpg)

    **Spare 10% auf deine Bestellung**

    ## L-Arginin

    Ein ARGI+® Stick ergibt einen leckeren Drink mit L-Arginin, Vitamin C, D, K, B6, B12 und Folsäure. Schmeckt wunderbar fruchtig nach Beeren und Trauben. Die praktischen Portionsbeutel sind perfekt für unterwegs. Einfach einstecken für das Fitnessstudio oder auf Reisen.

    ![ARGI+](https://storage.kula.app/assets/public/F6349114-B990-4220-B693-1401F32035D5/original.jpg)

    **Spare 10% auf deine Bestellung**

    ## Zink & Vitamin B12

    Mit Forever Focus™ gibt es nun endlich ein Nahrungsergänzungsmittel, das dir dabei hilft die Hürden deines schnellebigen Alltags optimal zu meistern. Neben Citicolin enthält Forever Focus™ die Vitamine B5, B6, B12 und Zink. Abgerundet wird diese kraftvolle Produktformel durch Extrakte aus Grünem Tee, Ginkgo, Rosenwurz und GUarana. Bleibe scharfsinning und konzentriert mit Forever Focus™.

    ![Forever Focus](https://storage.kula.app/assets/public/DD8EE340-9F1F-4803-B0E6-6426AFD0A479/original.jpg)

    **Spare 10% auf deine Bestellung**
    """

    var body: some View {
        ScrollView {
            CDMarkdownDefaultView(text: text)
                .environment(\.markdownParserCache, .shared)
                .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
