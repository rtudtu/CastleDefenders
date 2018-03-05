/*******************************************************************************
 * Videogame Project                  // Date: February 27, 2018
 * ARTG 2260: Programming Basics      // Instructor: Jose
 * Written By: Richard Tu             // Email: tu.r@husky.neu.edu
 * Title: Castle Defenders
 * Description: A game where you play as a hero with special abilities and build
 *              a defense that will withstand the zombie invasion!
 *              -Protect your villagers! They pay you taxes!
 *              -Knight:
 *                      Left Click - semi circle slash for 75 dmg - cost 10 energy
 *                      <Hold> Left Click - 30 dmg sword at no cost
 *                      Right Click - full circle slash for 150 dmg - cost 20 energy
 *                      <Hold> Right Click - Shield - cost .2 energy per frame (approx 12 energy per second)
 *              -Ranger:
 *                      Left Click - Shoots one arrow - cost one arrow
 *                      <Hold> Left Click - Shoots one large arrow piercing through enemies - cost 10 arrows
 *                      Right Click - Shoots fan of 5 arrows - cost 10 arrows
 *                      <Hold> Right Click - Shoots more arrows longer held down - cost x arrows or all arrows
 *              -Mage: <Coming Soon>
 ******************************************************************************/

Use <W>, <A>, <S>, <D> to move

Use <1>, <2>, <3>, <4>, <5>, <6> to:
Build wall (5000hp) - 50 gold
Build gate (5000hp) - 100 gold
Build knight tower (2500hp) - 150 gold
Build ranger tower (1000hp) - 150 gold
Repair - gold cost proportional to hp/maxhp
Sell - half the cost proportional to hp/maxhp

Different Attacks/Abilities:
Left Click
<Hold> Left Click
Right Click
<Hold> right Click

Zombies will path to the closest villager, then to either the crystal/player depending
on which is closer. If a villager is more than 1.5x the distance away than the 
crystal/player, then zombie will go for the crystal/player instead